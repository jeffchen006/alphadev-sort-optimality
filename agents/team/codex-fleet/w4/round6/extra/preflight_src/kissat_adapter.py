"""Fresh Kissat solve for each accumulated formula; keep checked UNSAT proofs."""
import hashlib
import json
import math
import os
from pathlib import Path
import resource
import subprocess
import time

KISSAT = '/path/to/workspace/schur6/bin/kissat'


class SearchLimit(Exception):
    pass


class Solver:
    def __init__(self, name=None, with_proof=False):
        self.clauses = []
        self.model = None
        self.iteration = 0
        self.stem = Path(os.environ['W4_QUERY_STEM'])
        self.deadline = float(os.environ['W4_QUERY_DEADLINE'])
        self.peak_rss = 0
        self.solver_cpu = 0.0
        self.sign = {}

    def __enter__(self):
        return self

    def __exit__(self, *args):
        pass

    def set_phases(self, phases):
        self.sign = {abs(lit): 1 if lit > 0 else -1 for lit in phases}

    def append_formula(self, clauses):
        self.clauses.extend(clauses)

    def solve(self):
        self.iteration += 1
        cnf = self.stem.with_suffix('.cnf')
        proof = self.stem.with_suffix('.drat')
        variables = max((abs(x) for c in self.clauses for x in c), default=0)
        with cnf.open('w') as stream:
            stream.write(f'p cnf {variables} {len(self.clauses)}\n')
            for clause in self.clauses:
                stream.write(' '.join(str(lit*self.sign.get(abs(lit),1)) for lit in clause)+' 0\n')
        digest = hashlib.sha256(cnf.read_bytes()).hexdigest()
        remaining = self.deadline - time.monotonic()
        if remaining <= 0:
            raise SearchLimit('setup reached the window limit')
        raw = self.stem.with_name(self.stem.name+f'_kissat_{self.iteration:02d}.log')
        command = [KISSAT, '-f', f'--time={math.ceil(remaining)}', '--seed=711', str(cnf), str(proof)]
        started = time.monotonic()
        usage = resource.getrusage(resource.RUSAGE_CHILDREN)
        cpu_before = usage.ru_utime + usage.ru_stime
        limited = False
        with raw.open('w') as stream:
            process = subprocess.Popen(command, stdout=stream, stderr=subprocess.STDOUT)
            while process.poll() is None:
                try:
                    process.wait(timeout=min(10, max(.01, self.deadline-time.monotonic())))
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
                if rss > 2_850_000 or time.monotonic() >= self.deadline:
                    limited = process.poll() is None
                    if limited:
                        process.terminate()
                        try:
                            process.wait(timeout=2)
                        except subprocess.TimeoutExpired:
                            process.kill()
                            process.wait()
                    break
        result = raw.read_text()
        usage = resource.getrusage(resource.RUSAGE_CHILDREN)
        self.solver_cpu += usage.ru_utime + usage.ru_stime - cpu_before
        status = 'SAT' if process.returncode == 10 and 's SATISFIABLE' in result else (
            'UNSAT' if process.returncode == 20 and 's UNSATISFIABLE' in result else 'UNKNOWN')
        if status == 'SAT':
            self.model = [int(x) for line in result.splitlines() if line.startswith('v ')
                          for x in line[2:].split() if int(x)]
            self.model = [lit*self.sign.get(abs(lit),1) for lit in self.model]
            assignment = set(self.model)
            assert all(any(x in assignment for x in clause) for clause in self.clauses), 'Bad SAT assignment'
        print(json.dumps(dict(step='kissat', iteration=self.iteration, status=status,
            returncode=process.returncode, limited=limited, command=command,
            seconds=round(time.monotonic()-started, 3), cnf_sha256=digest,
            peak_job_rss_kib=self.peak_rss,
            solver_cpu_seconds=round(self.solver_cpu, 3), cpu_counter='solver_only')), flush=True)
        if status == 'UNKNOWN':
            raise SearchLimit('Kissat time or resource limit')
        return status == 'SAT'

    def get_model(self):
        return self.model

    def get_proof(self):
        # Kissat retains its binary DRAT file. The controller checks that file.
        return []
