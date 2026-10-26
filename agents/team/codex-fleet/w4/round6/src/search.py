"""Whole-core routing, including partial columns used only as move data."""
import argparse
import itertools
import json
from pathlib import Path
import random
import subprocess
import sys
import time

from kissat_adapter import Solver, SearchLimit
from spine_encode import SpineEnc
from reference_window import OPS, CASES, GOALS, read, concrete, reg

PROJECT = Path('/path/to/repo')


def emit(program, snapshots, path):
    lines = [f'# n=5 model=out iset=I1 source=w4-partial-data k={len(program)}']
    for j, (t, r) in enumerate(snapshots):
        if t == 0:
            lines.append(f'out {j}, {reg(r)}')
    for i, (op, d, s) in enumerate(program):
        lines.append(f'{OPS[op]} {reg(d)}, {reg(s)}')
        for j, (t, r) in enumerate(snapshots):
            if t == i+1:
                lines.append(f'out {j}, {reg(r)}')
    Path(path).write_text('\n'.join(lines)+'\n')


def inspect(program, nr, comparisons):
    cols, states = concrete(program, nr)
    bad = set()
    for i, expected in comparisons.items():
        _, d, s = program[i]
        for actual, target in zip((states[i][0][d], states[i][0][s]), expected):
            bad.update(t for t in range(541) if actual[t] != target[t])
    witnesses = []
    for g in GOALS:
        exact = [(t+1, r) for t, r, c in cols if c == g]
        witnesses.append(exact[0] if exact else None)
    partial = [(i, d) for i, (o, d, s) in enumerate(program)
               if o > 1 and None in states[i+1][0][d]
               and any(v is not None for v in states[i+1][0][d])]
    data_reads = [(i, s) for i, (o, d, s) in enumerate(program)
                  if o != 1 and None in states[i][0][s]
                  and any(v is not None for v in states[i][0][s])]
    return cols, bad, witnesses, partial, data_reads


def solve(a):
    began = time.monotonic()
    original, used = read(a.seed)
    _, original_states = concrete(original, used)
    comparisons = {i: (original_states[i][0][d], original_states[i][0][s])
                   for i, (op, d, s) in enumerate(original) if op == 1}
    p = list(original)
    if a.delete is not None:
        assert p[a.delete][0] != 1
        del p[a.delete]
        comparisons = {i-(i>a.delete): v for i, v in comparisons.items()}
    k = len(p)
    nr = a.registers or used-1
    e = SpineEnc(5, k, R=nr, iset='I1', outmode='snap', rules=())
    domains, destinations, sources = [], [], []
    for i, (op, d, s) in enumerate(p):
        cmp = op == 1
        domain = [OPS[op]] if a.fixed else ['cmp'] if cmp else [x for x in OPS if x != 'cmp']
        dest = d if a.fixed or (not cmp and not a.free_dest) else None
        source = s if a.fixed else None
        domains.append(domain)
        destinations.append(dest)
        sources.append(source)
        e.cl(*[e.op[i][o] for o in domain])
        if dest is not None:
            e.cl(e.d[i][dest])
        if source is not None:
            e.cl(e.s[i][source])
    if a.wrong_output:
        e.cl(e.osnap[0][0])
    e.configure(p, domains, destinations, sources, comparisons)
    rng = random.Random(9031)
    strict = [i for i, c in enumerate(CASES) if len(set(c)) == 5]
    chosen = set(range(541)) if a.all_cases else {0, 1, 2}|set(rng.sample(strict, a.initial))
    for t in sorted(chosen):
        e.add_case(t, CASES[t])
    print(json.dumps(dict(step='scope', k=k, registers=nr, delete=a.delete,
                         fixed=a.fixed, free_dest=a.free_dest, comparison_positions=sorted(comparisons),
                         initial_cases=sorted(chosen), seed=a.seed,
                         assumptions=['G1','G2','G3','G4','A2','A4','A11'])), flush=True)
    with Solver() as solver:
        pushed = 0
        for iteration in itertools.count():
            solver.append_formula(e.clauses[pushed:])
            pushed = len(e.clauses)
            print(json.dumps(dict(step='solve', iteration=iteration, cases=len(chosen),
                                 variables=e.nvars, clauses=pushed)), flush=True)
            if not solver.solve():
                print(json.dumps(dict(status='UNSAT', cases=len(chosen),
                                     seconds=time.monotonic()-began)), flush=True)
                return
            program, out = e.decode(solver.get_model())
            q = [(OPS.index(o), d, s) for o, d, s in program]
            cols, bad, witnesses, partial, data_reads = inspect(q, nr, comparisons)
            added = set(bad)-chosen
            # Check the actual SAT-selected output snapshots on all orders.
            column_map = {(t+1, r): c for t, r, c in cols}
            errors = []
            for j, snap in enumerate(out):
                c = column_map[snap]
                failures = [t for t in range(541) if c[t] != GOALS[j][t]]
                errors.append(len(failures))
                added.update(failures)
            added -= chosen
            # Use a bounded counterexample batch. Every omitted failure is
            # checked again before acceptance.
            added = set(sorted(added)[:16])
            saved = a.output+f'.model{iteration:03d}.s'
            emit(q, out, saved)
            check = subprocess.run([sys.executable, '-B', str(PROJECT/'shared/judge.py'),
                                    saved, '--strict', '--model', 'out'], capture_output=True, text=True)
            Path(saved+'.judge').write_text(check.stdout+check.stderr)
            print(json.dumps(dict(step='candidate', iteration=iteration, errors=errors,
                                 comparison_bad=len(bad), partial_columns=partial,
                                 partial_data_reads=data_reads, added=sorted(added),
                                 judge_returncode=check.returncode, judge=check.stdout+check.stderr,
                                 path=saved)), flush=True)
            if not check.returncode and check.stdout.startswith('PASS ') and not bad:
                Path(a.output).write_bytes(Path(saved).read_bytes())
                print(json.dumps(dict(status='PASS', path=a.output, k=k,
                                     seconds=time.monotonic()-began)), flush=True)
                return
            if added:
                for t in sorted(added):
                    e.add_case(t, CASES[t])
                chosen |= added
            else:
                # Initial flags are relaxed. Retain alternative snapshots for
                # the same core when blocking a strict-rejected model.
                outputs = [e.osnap[j][r if t==0 else e.n+t-1] for j, (t,r) in enumerate(out)]
                e.cl(*[-v for i, (op,d,s) in enumerate(q)
                       for v in (e.op[i][OPS[op]], e.d[i][d], e.s[i][s])],
                     *[-v for v in outputs])


if __name__ == '__main__':
    ap = argparse.ArgumentParser()
    ap.add_argument('seed')
    ap.add_argument('output')
    ap.add_argument('--delete', type=int)
    ap.add_argument('--registers', type=int, default=0)
    ap.add_argument('--initial', type=int, default=16)
    ap.add_argument('--free-dest', action='store_true')
    ap.add_argument('--fixed', action='store_true')
    ap.add_argument('--all-cases', action='store_true')
    ap.add_argument('--wrong-output', action='store_true')
    try:
        solve(ap.parse_args())
    except SearchLimit as error:
        print(json.dumps(dict(status='UNKNOWN', reason=str(error))), flush=True)
