#!/usr/bin/env python3
"""Run the round-2 window encoder with an external, bounded Kissat job."""
import hashlib
import importlib.util
import json
import math
import os
from pathlib import Path
import resource
import shutil
import subprocess
import sys
import time

BASE = Path(__file__).resolve().parents[1]
KISSAT = Path('/path/to/workspace/schur6/bin/kissat')
spec = importlib.util.spec_from_file_location('window_cnf', BASE.parent/'round2/src/window_cnf.py')
w = importlib.util.module_from_spec(spec)
spec.loader.exec_module(w)


class ExternalSolver:
    def __init__(self, seconds, tag, random_seed):
        self.deadline = time.monotonic()+seconds
        self.tag = tag
        self.random_seed = random_seed
        self.body_path = BASE/'cnf'/f'{tag}.body'
        self.body = self.body_path.open('w')
        self.variables = self.clauses = self.iteration = 0
        self.model = None
        self.peak_job_rss_kib = 0
        self.phases = {}
        self.phase_renaming = os.environ.get('W4_KISSAT_PHASES') == '1'

    def add_clause(self, clause):
        self.body.write(' '.join(map(str, clause))+' 0\n')
        self.variables = max(self.variables, max(map(abs, clause), default=0))
        self.clauses += 1

    def set_phases(self, phases):
        # Literal complementation maps a requested negative phase to Kissat's
        # positive initial phase. It is a bijection, not an added constraint.
        if self.phase_renaming:
            self.phases.update({abs(x): x > 0 for x in phases})

    def conf_budget(self, budget):
        pass

    def solve_limited(self):
        self.iteration += 1
        remaining = self.deadline-time.monotonic()
        if remaining <= 0:
            return None
        self.body.flush()
        formula = BASE/'cnf'/f'{self.tag}.cnf'
        with formula.open('w') as stream:
            stream.write(f'p cnf {self.variables} {self.clauses}\n')
            with self.body_path.open() as source:
                if self.phase_renaming:
                    for line in source:
                        stream.write(' '.join(str(-int(x) if self.phases.get(abs(int(x))) is False
                                                  else int(x)) for x in line.split())+'\n')
                else:
                    shutil.copyfileobj(source, stream)
        digest = hashlib.sha256(formula.read_bytes()).hexdigest()
        expected = os.environ.get('W4_EXPECTED_INITIAL_HASH')
        if self.iteration == 1 and expected:
            assert digest == expected, ('Resumed formula differs', digest, expected)
        raw = BASE/'logs'/f'{self.tag}_kissat_{self.iteration:02d}.log'
        began = time.monotonic()
        limited = False
        with raw.open('w') as output:
            process = subprocess.Popen([str(KISSAT), f'--time={math.ceil(remaining)}',
                                        f'--seed={self.random_seed}', str(formula)],
                                       stdout=output, stderr=subprocess.STDOUT)
            while process.poll() is None:
                try:
                    process.wait(timeout=min(30, max(0.01, self.deadline-time.monotonic())))
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
                self.peak_job_rss_kib = max(self.peak_job_rss_kib, rss)
                if rss > 2_850_000 or time.monotonic() >= self.deadline:
                    limited = process.poll() is None
                    if limited:
                        process.terminate()
                        try:
                            process.wait(timeout=3)
                        except subprocess.TimeoutExpired:
                            process.kill()
                            process.wait()
                    break
                if process.poll() is None:
                    print(json.dumps({'phase':'kissat_working', 'iteration':self.iteration,
                                      'seconds':round(time.monotonic()-began,3),
                                      'job_rss_kib':rss}), flush=True)
        result = raw.read_text()
        status = (True if process.returncode == 10 and 's SATISFIABLE' in result else
                  False if process.returncode == 20 and 's UNSATISFIABLE' in result else None)
        if status is True:
            self.model = [int(x) for line in result.splitlines() if line.startswith('v ')
                          for x in line[2:].split() if int(x)]
            if self.phase_renaming:
                self.model = [-x if self.phases.get(abs(x)) is False else x for x in self.model]
            # Check the complete model against the exact emitted clauses.
            model = set(self.model)
            assert all(any(int(x) in model for x in line.split()[:-1])
                       for line in self.body_path.read_text().splitlines()), 'Invalid SAT model'
        print(json.dumps({'phase':'kissat_result', 'iteration':self.iteration,
                          'status':str(status), 'returncode':process.returncode,
                          'limited':limited, 'seconds':round(time.monotonic()-began,3),
                          'cnf_sha256':digest, 'raw_log':str(raw),
                          'phase_renaming':self.phase_renaming,
                          'peak_job_rss_kib':self.peak_job_rss_kib,
                          'child_cpu_seconds':round(resource.getrusage(resource.RUSAGE_CHILDREN).ru_utime+
                                                    resource.getrusage(resource.RUSAGE_CHILDREN).ru_stime,3)}), flush=True)
        return status

    def get_model(self):
        return self.model

    def accum_stats(self):
        return {'peak_job_rss_kib':self.peak_job_rss_kib,
                'child_cpu_seconds':round(resource.getrusage(resource.RUSAGE_CHILDREN).ru_utime+
                                          resource.getrusage(resource.RUSAGE_CHILDREN).ru_stime,3)}

    def delete(self):
        self.body.close()
        self.body_path.unlink(missing_ok=True)


if __name__ == '__main__':
    assert os.getpriority(os.PRIO_PROCESS, 0) == 19, 'Use nice -n 19'
    resource.setrlimit(resource.RLIMIT_AS, (2800*1024*1024, 2800*1024*1024))
    if not (BASE/'handoff/analysis.json').exists():
        subprocess.run([sys.executable, '-B', str(BASE/'src/analyze_failures.py')],
                       check=True)
    if not (BASE/'repair/controls.json').exists():
        subprocess.run([sys.executable, '-B', '-c',
                        'from repair_windows import controls; controls()'],
                       cwd=BASE/'src', check=True)
    seconds = float(sys.argv[sys.argv.index('--seconds')+1])
    tag = Path(sys.argv[sys.argv.index('--out')+1]).stem
    seed = int(sys.argv[sys.argv.index('--random-seed')+1]) if '--random-seed' in sys.argv else 0
    w.Solver = lambda name: ExternalSolver(seconds, tag, seed)
    decode = w.Window.decode
    def save_decoded(window):
        core, outputs = decode(window)
        index = getattr(window, '_saved_model_count', 0)+1
        window._saved_model_count = index
        path = BASE/'candidates'/f'{tag}_model{index:02d}.s'
        w.write(path, core, window.names, outputs)
        print(json.dumps({'phase':'decoded_model','path':str(path),'k':len(core)}),flush=True)
        return core, outputs
    w.Window.decode = save_decoded
    w.main()
