"""Sequential external Kissat with one shared wall limit per query."""
import hashlib
import json
import math
import os
from pathlib import Path
import resource
import subprocess
import time

HERE = Path(__file__).resolve().parents[1]
KISSAT = Path('/path/to/workspace/schur6/bin/kissat')


class KissatSolver:
    def __init__(self, seconds, tag):
        self.deadline = time.monotonic() + seconds
        self.tag = tag
        self.clauses = []
        self.model = None
        self.records = []
        self.peak_rss = 0
        self.reason = None
        self.child_start = resource.getrusage(resource.RUSAGE_CHILDREN)

    def __enter__(self):
        return self

    def __exit__(self, *args):
        return False

    def add_clause(self, clause):
        assert clause and all(type(x) is int and x != 0 for x in clause)
        self.clauses.append(clause)

    def set_phases(self, phases):
        # Phase preferences are not constraints. External Kissat uses defaults.
        pass

    def conf_budget(self, budget):
        pass

    def solve_limited(self):
        if time.monotonic() >= self.deadline:
            self.reason = 'UNKNOWN_WALL_LIMIT'
            return None
        iteration = len(self.records) + 1
        formula = HERE/'cnf'/f'{self.tag}.cnf'
        nvars = max(abs(x) for cl in self.clauses for x in cl)
        with formula.open('w') as stream:
            stream.write(f'p cnf {nvars} {len(self.clauses)}\n')
            for cl in self.clauses:
                stream.write(' '.join(map(str, cl)) + ' 0\n')
        digest = hashlib.sha256(formula.read_bytes()).hexdigest()
        remaining = self.deadline - time.monotonic()
        if remaining <= 0:
            self.reason = 'UNKNOWN_WALL_LIMIT'
            return None
        raw = HERE/'logs'/f'{self.tag}_kissat_{iteration:02d}.log'
        start = last_report = time.monotonic()
        reason = None
        with raw.open('w') as output:
            process = subprocess.Popen([str(KISSAT), f'--time={max(1, math.ceil(remaining))}',
                                        '--seed=0', str(formula)],
                                       stdout=output, stderr=subprocess.STDOUT)
            try:
                while process.poll() is None:
                    try:
                        process.wait(timeout=min(2, max(.01, self.deadline-time.monotonic())))
                    except subprocess.TimeoutExpired:
                        pass
                    rss = 0
                    for pid in (os.getpid(), process.pid):
                        try:
                            for line in Path(f'/proc/{pid}/status').read_text().splitlines():
                                if line.startswith('VmRSS:'):
                                    rss += int(line.split()[1])
                        except FileNotFoundError:
                            pass
                    self.peak_rss = max(self.peak_rss, rss)
                    if rss > 2_800_000:
                        reason = 'UNKNOWN_MEMORY_LIMIT'
                        break
                    if time.monotonic() >= self.deadline and process.poll() is None:
                        reason = 'UNKNOWN_WALL_LIMIT'
                        break
                    if time.monotonic()-last_report >= 30:
                        print(json.dumps({'event':'kissat_working','tag':self.tag,
                                          'seconds':time.monotonic()-start,'rss_kib':rss}),flush=True)
                        last_report = time.monotonic()
            finally:
                if process.poll() is None:
                    process.terminate()
                    try:
                        process.wait(timeout=2)
                    except subprocess.TimeoutExpired:
                        process.kill()
                        process.wait()
        data = raw.read_text()
        status = ('SAT' if process.returncode == 10 and 's SATISFIABLE' in data else
                  'UNSAT' if process.returncode == 20 and 's UNSATISFIABLE' in data else
                  reason or 'UNKNOWN_SOLVER_LIMIT')
        record = {'iteration':iteration,'status':status,'seconds':time.monotonic()-start,
                  'returncode':process.returncode,'cnf_sha256':digest,'variables':nvars,
                  'clauses':len(self.clauses),'raw_log':str(raw)}
        if status == 'SAT':
            self.model = [int(x) for line in data.splitlines() if line.startswith('v ')
                          for x in line[2:].split() if int(x)]
            assignment = set(self.model)
            assert all(any(x in assignment for x in cl) for cl in self.clauses), 'Invalid SAT model'
            record['cnf_model_checked'] = True
        self.records.append(record)
        print(json.dumps({'event':'kissat_result','tag':self.tag,**record}),flush=True)
        if status not in ('SAT','UNSAT'):
            self.reason = status
            # End the outer loop without repeated launches on a resource limit.
            self.deadline = time.monotonic()
        formula.unlink(missing_ok=True)
        return True if status == 'SAT' else False if status == 'UNSAT' else None

    def get_model(self):
        return self.model

    def accum_stats(self):
        usage = resource.getrusage(resource.RUSAGE_CHILDREN)
        return {'peak_job_rss_kib':self.peak_rss,
                'child_cpu_seconds':usage.ru_utime+usage.ru_stime-self.child_start.ru_utime-self.child_start.ru_stime,
                'solver_calls':self.records,'limit_reason':self.reason}
