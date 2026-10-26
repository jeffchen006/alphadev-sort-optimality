"""Positive controls for symbolic register selection and partial data paths."""
import json
import os
from pathlib import Path
import resource
import subprocess
import sys
import time

from kissat_adapter import Solver
from spine_encode import SpineEnc
from reference_window import OPS, CASES, read, concrete
from search import emit

BASE = Path(__file__).resolve().parents[1]
PROJECT = BASE.parents[4]


def run(tag, seed, free):
    p, used = read(seed)
    _, states = concrete(p, used)
    cmps = {i: (states[i][0][d], states[i][0][s])
            for i, (o,d,s) in enumerate(p) if o == 1}
    e = SpineEnc(5, len(p), R=used-1, iset='I1', outmode='snap', rules=())
    domains, destinations, sources = [], [], []
    for i, (op,d,s) in enumerate(p):
        domain = [o for o in OPS if o != 'cmp'] if i in free else [OPS[op]]
        destination = None if op == 1 else d
        source = None if i in free or op == 1 else s
        domains.append(domain)
        destinations.append(destination)
        sources.append(source)
        e.cl(*[e.op[i][o] for o in domain])
        if destination is not None:
            e.cl(e.d[i][destination])
        if source is not None:
            e.cl(e.s[i][source])
    e.configure(p, domains, destinations, sources, cmps)
    for t, ranks in enumerate(CASES):
        e.add_case(t, ranks)
    os.environ['W4_QUERY_STEM'] = str(BASE/'cnf'/tag)
    os.environ['W4_QUERY_DEADLINE'] = str(time.monotonic()+120)
    with Solver() as solver:
        solver.append_formula(e.clauses)
        assert solver.solve(), 'Known strict program must remain feasible'
        program, snapshots = e.decode(solver.get_model())
    q = [(OPS.index(o),d,s) for o,d,s in program]
    output = BASE/'candidates'/f'{tag}.s'
    emit(q, snapshots, output)
    checked = subprocess.run([sys.executable, '-B', str(PROJECT/'shared/judge.py'),
                              str(output), '--strict', '--model', 'out'], capture_output=True, text=True)
    (BASE/'logs'/f'{tag}.judge').write_text(checked.stdout+checked.stderr)
    assert not checked.returncode and checked.stdout.startswith('PASS '), checked.stdout+checked.stderr
    return dict(tag=tag, free=sorted(free), cases=len(CASES), variables=e.nvars,
                clauses=len(e.clauses), path=str(output), judge=checked.stdout+checked.stderr)


if __name__ == '__main__':
    assert os.getpriority(os.PRIO_PROCESS, 0) == 19
    os.sched_setaffinity(0, {min(os.sched_getaffinity(0))})
    resource.setrlimit(resource.RLIMIT_AS, (2800*1024**2, 2800*1024**2))
    rows = [run('symbolic_positive32', BASE/'seeds/c8_108b52d1733c50f9.s', {3,7,13,20,27}),
            run('symbolic_partial36', BASE/'seeds/partial_data_control.s', {1,2})]
    (BASE/'logs/symbolic_controls.json').write_text(json.dumps(rows, indent=2)+'\n')
    print(json.dumps(rows), flush=True)
