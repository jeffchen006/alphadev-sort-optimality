"""Search global source changes after one deletion.

Destinations of writes and instruction classes stay fixed. All comparison
operands and all write sources can change. Conditional-move conditions can
change. The imported encoder uses a relaxed initial state. A solver candidate
must pass the independent conservative evaluator, then the reference judge.
"""
import argparse
import itertools
import json
from pathlib import Path
import random
import sys
import time

ROOT = Path('/path/to/repo')
sys.path.insert(0, str(ROOT / 'agents/sat'))
sys.path.insert(0, str(Path(__file__).resolve().parents[2] / 'src'))
from encode import Enc
from pysat.card import CardEnc, EncType
from pysat.solvers import Solver
from window_sat import read, concrete, reg, OPS, CASES, GOALS


def solve(args):
    program, nr = read(args.seed)
    nr = nr - 1 + args.fresh
    if args.delete >= 0:
        del program[args.delete]
    k = len(program)
    e = Enc(5, k, R=nr, iset='I1', outmode='snap', rules=())
    changes = []
    comparison_changes = []
    phases = []
    for i, (op, d, src) in enumerate(program):
        if args.general:
            pass
        elif op == 1:
            e.cl(e.op[i]['cmp'])
        elif op == 0:
            e.cl(e.op[i]['mov'])
            e.cl(e.d[i][d])
        else:
            e.cl(*[e.op[i][s] for s in OPS[2:]])
            e.cl(e.d[i][d])
        ch = e.new()
        # If ch is false, preserve the original instruction.
        e.cl(ch, e.op[i][OPS[op]])
        e.cl(ch, e.d[i][d])
        e.cl(ch, e.s[i][src])
        changes.append(ch)
        if op == 1:
            comparison_changes.append(ch)
        phases.extend([e.op[i][OPS[op]], e.d[i][d], e.s[i][src], -ch])
        if args.conditions_only:
            e.cl(e.d[i][d])
            e.cl(e.s[i][src])
            if args.eq_only and op >= 2:
                e.cl(*[e.op[i][name] for name in
                       (('cmovl', 'cmovle') if op in (2, 3) else ('cmovg', 'cmovge'))])
        if i < args.prefix:
            e.cl(-ch)
    if args.control:
        for ch in changes:
            e.cl(-ch)
    else:
        # The mutation bound includes all comparison-operand changes.
        if args.changes:
            card = CardEnc.atmost(changes, args.changes, top_id=e.nvars,
                                 encoding=EncType.seqcounter)
            e.nvars = card.nv
            e.clauses.extend(card.clauses)

    rnd = random.Random(args.random_seed)
    strict = [i for i, x in enumerate(CASES) if len(set(x)) == 5]
    chosen = set(rnd.sample(strict, 12))
    chosen |= set(rnd.sample(range(541), 4))
    for t in sorted(chosen):
        e.add_type(CASES[t])
    solver = Solver(name='cadical195')
    solver.set_phases(phases)
    pushed = 0
    began = time.monotonic()
    for iteration in itertools.count():
        for clause in e.clauses[pushed:]:
            solver.add_clause(clause)
        pushed = len(e.clauses)
        print(json.dumps({'step': 'solve', 'iteration': iteration,
                          'types': len(chosen), 'variables': e.nvars,
                          'clauses': pushed, 'seconds': time.monotonic()-began}), flush=True)
        status = solver.solve()
        if not status:
            print(json.dumps({'status': 'UNSAT', 'types': len(chosen),
                              'seconds': time.monotonic()-began}), flush=True)
            return
        candidate, outmap = e.decode(solver.get_model())
        p = [(OPS.index(op), d, s) for op, d, s in candidate]
        columns, _ = concrete(p, nr)
        witnesses = []
        added = set()
        for j, goal in enumerate(GOALS):
            exact = [(t, r) for t, r, col in columns if col == goal]
            witnesses.append(exact[0] if exact else None)
            if not exact:
                for _, _, col in columns:
                    if all(col[t] == goal[t] for t in chosen):
                        added.add(next(t for t in range(541) if col[t] != goal[t]))
        if all(w is not None for w in witnesses):
            body = [f'# n=5 model=out iset=I1 source=w6-source-sat k={k}']
            for j, (t, r) in enumerate(witnesses):
                if t == -1:
                    body.append(f'out {j}, {reg(r)}')
            for t, (op, d, s) in enumerate(p):
                body.append(f'{OPS[op]} {reg(d)}, {reg(s)}')
                for j, (when, r) in enumerate(witnesses):
                    if when == t:
                        body.append(f'out {j}, {reg(r)}')
            Path(args.output).write_text('\n'.join(body)+'\n')
            print(json.dumps({'status': 'CANDIDATE', 'file': args.output,
                              'types': len(chosen), 'seconds': time.monotonic()-began}), flush=True)
            return
        if not added - chosen:
            # The relaxed model can use a scratch sentinel. Exclude this exact
            # instruction list when more weak orders cannot remove it.
            block = []
            for i, (op, d, s) in enumerate(p):
                block.extend([-e.op[i][OPS[op]], -e.d[i][d], -e.s[i][s]])
            e.cl(*block)
        for t in sorted(added - chosen):
            e.add_type(CASES[t])
        chosen |= added


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('seed')
    parser.add_argument('output')
    parser.add_argument('--delete', type=int, default=-1)
    parser.add_argument('--changes', type=int, default=6)
    parser.add_argument('--random-seed', type=int, default=6801)
    parser.add_argument('--prefix', type=int, default=4)
    parser.add_argument('--general', action='store_true')
    parser.add_argument('--fresh', type=int, default=0)
    parser.add_argument('--conditions-only', action='store_true')
    parser.add_argument('--eq-only', action='store_true')
    parser.add_argument('--control', action='store_true')
    solve(parser.parse_args())
