"""Run the unchanged round-6 repair relation with external Kissat.

One query gets a shared wall budget across counterexample refinements.
No timeout is an exclusion. SAT models are checked against the emitted CNF.
"""
from pathlib import Path
import argparse
import hashlib
import importlib.util
import json
import math
import os
import resource
import shutil
import subprocess
import sys
import time

sys.dont_write_bytecode = True
HERE = Path(__file__).resolve().parent
KISSAT = Path('/path/to/workspace/schur6/bin/kissat')


class Limit(Exception):
    pass


class ExternalSolver:
    def __init__(self, seconds, tag, random_seed=0):
        self.deadline = time.monotonic() + seconds
        self.tag = tag
        self.random_seed = random_seed
        self.body_path = HERE/'cnf'/f'{tag}.body'
        self.body = self.body_path.open('w')
        self.variables = self.clauses = self.iteration = 0
        self.model = None
        self.peak_rss_kib = 0
        self.process = None

    def set_phases(self, phases):
        # Kissat uses its default phases. This changes no formula constraints.
        pass

    def add_clause(self, clause):
        self.body.write(' '.join(map(str, clause))+' 0\n')
        self.variables = max(self.variables, max(map(abs, clause), default=0))
        self.clauses += 1

    def solve(self):
        self.iteration += 1
        remaining = self.deadline-time.monotonic()
        if remaining <= 0:
            raise Limit('UNKNOWN_WALL_LIMIT')
        self.body.flush()
        formula = HERE/'cnf'/f'{self.tag}.cnf'
        with formula.open('w') as stream:
            stream.write(f'p cnf {self.variables} {self.clauses}\n')
            with self.body_path.open() as source:
                shutil.copyfileobj(source, stream)
        digest = hashlib.sha256(formula.read_bytes()).hexdigest()
        raw = HERE/'logs'/f'{self.tag}_kissat_{self.iteration:02d}.log'
        began = last_report = time.monotonic()
        remaining = self.deadline-began
        if remaining <= 0:
            raise Limit('UNKNOWN_WALL_LIMIT')
        reason = None
        with raw.open('w') as output:
            self.process = subprocess.Popen(
                [str(KISSAT), f'--time={math.ceil(remaining)}',
                 f'--seed={self.random_seed}', str(formula)],
                stdout=output, stderr=subprocess.STDOUT)
            try:
                while self.process.poll() is None:
                    try:
                        self.process.wait(timeout=min(2, max(.01, self.deadline-time.monotonic())))
                    except subprocess.TimeoutExpired:
                        pass
                    rss = 0
                    for pid in (os.getpid(), self.process.pid):
                        try:
                            for line in Path(f'/proc/{pid}/status').read_text().splitlines():
                                if line.startswith('VmRSS:'):
                                    rss += int(line.split()[1])
                        except FileNotFoundError:
                            pass
                    self.peak_rss_kib = max(self.peak_rss_kib, rss)
                    if rss > 2_800_000:
                        reason = 'UNKNOWN_MEMORY_LIMIT'
                        break
                    if time.monotonic() >= self.deadline and self.process.poll() is None:
                        reason = 'UNKNOWN_WALL_LIMIT'
                        break
                    if time.monotonic()-last_report >= 30:
                        print(json.dumps(dict(step='kissat_working', iteration=self.iteration,
                                              seconds=time.monotonic()-began,
                                              job_rss_kib=rss)), flush=True)
                        last_report = time.monotonic()
            finally:
                if self.process.poll() is None:
                    self.process.terminate()
                    try:
                        self.process.wait(timeout=3)
                    except subprocess.TimeoutExpired:
                        self.process.kill()
                        self.process.wait()
        result = raw.read_text()
        code = self.process.returncode
        status = ('SAT' if code == 10 and 's SATISFIABLE' in result else
                  'UNSAT' if code == 20 and 's UNSATISFIABLE' in result else
                  reason or 'UNKNOWN_SOLVER_LIMIT')
        if status == 'SAT':
            self.model = [int(x) for line in result.splitlines() if line.startswith('v ')
                          for x in line[2:].split() if int(x)]
            positive = set(self.model)
            with self.body_path.open() as source:
                assert all(any(int(x) in positive for x in line.split()[:-1])
                           for line in source), 'Invalid SAT model'
        print(json.dumps(dict(step='kissat_result', iteration=self.iteration,
                              solver_status=status, returncode=code,
                              seconds=time.monotonic()-began, cnf_sha256=digest,
                              variables=self.variables, clauses=self.clauses,
                              raw_log=str(raw), stats=self.accum_stats())), flush=True)
        if status not in ('SAT', 'UNSAT'):
            raise Limit(status)
        return status == 'SAT'

    def get_model(self):
        return self.model

    def accum_stats(self):
        usage = resource.getrusage(resource.RUSAGE_CHILDREN)
        return dict(peak_job_rss_kib=self.peak_rss_kib,
                    child_cpu_seconds=usage.ru_utime+usage.ru_stime)

    def close(self):
        self.body.close()
        self.body_path.unlink(missing_ok=True)
        (HERE/'cnf'/f'{self.tag}.cnf').unlink(missing_ok=True)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('seed')
    ap.add_argument('output')
    ap.add_argument('--meta')
    ap.add_argument('--slots')
    ap.add_argument('--seconds', type=float, default=1200)
    ap.add_argument('--random-seed', type=int, default=0)
    ap.add_argument('--all-cases', action='store_true')
    ap.add_argument('--control', action='store_true')
    ap.add_argument('--allow32', action='store_true')
    ap.add_argument('--predicates', action='store_true')
    args = ap.parse_args()
    assert os.getpriority(os.PRIO_PROCESS, 0) == 19, 'Use nice -n 19'
    resource.setrlimit(resource.RLIMIT_AS, (2800*1024**2, 2800*1024**2))
    # Pin this worker to one inherited CPU, including all child jobs.
    os.sched_setaffinity(0, {min(os.sched_getaffinity(0))})
    spec = importlib.util.spec_from_file_location('round6_repair', HERE.parent/'round6/sat_repair.py')
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    external = ExternalSolver(args.seconds, Path(args.output).stem, args.random_seed)
    module.Solver = lambda name: external
    try:
        module.solve(args)
    except Limit as error:
        print(json.dumps(dict(status=str(error), stats=external.accum_stats())), flush=True)
    finally:
        external.close()


if __name__ == '__main__':
    main()
