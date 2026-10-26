"""Bounded free-operand SAT repair with incremental weak-order tests.

The imported CNF encoder fixes scratch to a top sentinel and flags to equal.
UNSAT concerns that bounded relaxed neighbourhood only. Every SAT proposal is
checked on all 541 weak orders with conservative unknowns, then by the judge.
"""
import argparse
import hashlib
import itertools
import json
from pathlib import Path
import random
import resource
import sys
import time

sys.dont_write_bytecode = True
ROOT = Path('/path/to/repo')
sys.path.insert(0, str(ROOT / 'agents/sat'))
sys.path.insert(0, str(ROOT / 'agents/team/codex-fleet/w6/src'))
from encode import Enc
from pysat.card import CardEnc, EncType
from pysat.solvers import Solver
from window_sat import read, concrete, reg, OPS, CASES, GOALS


def emit(program, witnesses, output):
    lines = [f'# n=5 model=out iset=I1 source=w5-round3-sat k={len(program)}']
    for j, (t, r) in enumerate(witnesses):
        if t == -1:
            lines.append(f'out {j}, {reg(r)}')
    for t, (op, d, s) in enumerate(program):
        lines.append(f'{OPS[op]} {reg(d)}, {reg(s)}')
        for j, (when, r) in enumerate(witnesses):
            if when == t:
                lines.append(f'out {j}, {reg(r)}')
    Path(output).write_text('\n'.join(lines) + '\n')


def solve(args):
    resource.setrlimit(resource.RLIMIT_AS, (2900*1024**2, 2900*1024**2))
    began = time.monotonic()
    program, nr = read(args.seed)
    nr = nr - 1 + args.fresh
    if args.delete:
        removed = set(map(int, args.delete.split(',')))
        program = [x for i, x in enumerate(program) if i not in removed]
    if args.insert >= 0:
        program.insert(args.insert, (0, 0, 0))
    k = len(program)
    encoder = Enc
    if args.rank:
        from rank_encode import RankEnc
        encoder = RankEnc
    e = encoder(5, k, R=nr, iset='I1', outmode='snap', rules=())
    changes, phases = [], []
    for i, (op, d, s) in enumerate(program):
        ch = e.new()
        changes.append(ch)
        e.cl(ch, e.op[i][OPS[op]])
        e.cl(ch, e.d[i][d])
        e.cl(ch, e.s[i][s])
        # A change marker is true exactly when the instruction differs.
        e.cl(-ch, -e.op[i][OPS[op]], -e.d[i][d], -e.s[i][s])
        phases.extend([e.op[i][OPS[op]], e.d[i][d], e.s[i][s], -ch])
        if args.control or i < args.prefix:
            e.cl(-ch)
        if args.mode == 'sources':
            e.cl(*[e.op[i][x] for x in ([OPS[op]] if op < 2 else OPS[2:])])
            if op != 1:
                e.cl(e.d[i][d])
        elif args.mode == 'classes':
            e.cl(*[e.op[i][x] for x in ([OPS[op]] if op < 2 else OPS[2:])])
        elif args.mode == 'conditions':
            e.cl(e.d[i][d])
            e.cl(e.s[i][s])
            if op < 2:
                e.cl(e.op[i][OPS[op]])
            else:
                e.cl(*[e.op[i][x] for x in OPS[2:]])
    if args.changes >= 0:
        card = CardEnc.atmost(changes, args.changes, top_id=e.nvars,
                             encoding=EncType.seqcounter)
        e.nvars = card.nv
        e.clauses.extend(card.clauses)
    if args.fixed_outs:
        assert not args.delete and args.insert < 0
        registers = {f'P{i}': i for i in range(5)}
        time_index = -1
        written = {i: -1 for i in range(nr)}
        snapshots = {}
        for line in Path(args.seed).read_text().splitlines():
            line = line.split('#')[0].strip()
            if not line:
                continue
            op, d, s = line.replace(',', '').split()
            if op == 'out':
                r = registers[s]
                snapshots[int(d)] = (written[r], r)
            else:
                for r in (d, s):
                    if r not in registers:
                        registers[r] = len(registers)
                time_index += 1
                if op != 'cmp':
                    written[registers[d]] = time_index
        assert len(snapshots) == 5
        for j, (t, r) in snapshots.items():
            e.cl(e.osnap[j][r if t < 0 else 5+t])
            if t >= 0:
                e.cl(e.d[t][r])
    rnd = random.Random(args.random_seed)
    strict = [i for i, x in enumerate(CASES) if len(set(x)) == 5]
    chosen = set(rnd.sample(strict, args.cases))
    # Add the smallest error witnesses from the seed. This includes tie cases.
    columns, _ = concrete(program, nr)
    errors = set()
    for j, goal in enumerate(GOALS):
        best = min(columns, key=lambda col: sum(a != b for a, b in zip(col[2], goal)))
        errors.update(t for t in range(541) if best[2][t] != goal[t])
    chosen |= errors
    for t in sorted(chosen):
        e.add_type(CASES[t])
    solver = Solver(name=args.solver)
    solver.set_phases(phases)
    pushed = 0
    for iteration in itertools.count():
        for clause in e.clauses[pushed:]:
            solver.add_clause(clause)
        pushed = len(e.clauses)
        print(json.dumps({'step': 'solve', 'iteration': iteration, 'types': len(chosen),
                          'variables': e.nvars, 'clauses': pushed,
                          'seconds': time.monotonic()-began}), flush=True)
        if not solver.solve():
            print(json.dumps({'status': 'UNSAT', 'types': len(chosen),
                              'seconds': time.monotonic()-began,
                              'stats': solver.accum_stats()}), flush=True)
            return
        candidate, outmap = e.decode(solver.get_model())
        p = [(OPS.index(op), d, s) for op, d, s in candidate]
        columns, _ = concrete(p, nr)
        witnesses, added = [], set()
        for j, goal in enumerate(GOALS):
            exact = [(t, r) for t, r, col in columns if col == goal]
            witnesses.append(exact[0] if exact else None)
            if not exact:
                best = min(columns, key=lambda col: sum(col[2][t] != goal[t] for t in range(541)))
                failures = [t for t in range(541) if best[2][t] != goal[t] and t not in chosen]
                added.update(failures[:4])
                # Also exclude every conservative witness valid on current cases.
                for _, _, col in columns:
                    if all(col[t] == goal[t] for t in chosen):
                        fail = next((t for t in range(541) if col[t] != goal[t]), None)
                        if fail is not None:
                            added.add(fail)
        if all(w is not None for w in witnesses):
            emit(p, witnesses, args.output)
            print(json.dumps({'status': 'CANDIDATE', 'file': args.output,
                              'types': len(chosen), 'seconds': time.monotonic()-began}), flush=True)
            return
        print(json.dumps({'step': 'reject', 'added': sorted(added-chosen),
                          'edits': [i for i, x in enumerate(p) if x != program[i]]}), flush=True)
        # An exact instruction-list block is needed for scratch-sentinel artefacts.
        if not added-chosen:
            e.cl(*[-v for i, (op, d, s) in enumerate(candidate)
                   for v in (e.op[i][op], e.d[i][d], e.s[i][s])])
        for t in sorted(added-chosen):
            e.add_type(CASES[t])
        chosen |= added


if __name__ == '__main__':
    ap = argparse.ArgumentParser()
    ap.add_argument('seed')
    ap.add_argument('output')
    ap.add_argument('--changes', type=int, default=3)
    ap.add_argument('--mode', choices=['general', 'classes', 'sources', 'conditions'], default='general')
    ap.add_argument('--prefix', type=int, default=0)
    ap.add_argument('--fresh', type=int, default=1)
    ap.add_argument('--cases', type=int, default=12)
    ap.add_argument('--delete', default='')
    ap.add_argument('--insert', type=int, default=-1)
    ap.add_argument('--solver', default='cadical195')
    ap.add_argument('--random-seed', type=int, default=53001)
    ap.add_argument('--control', action='store_true')
    ap.add_argument('--fixed-outs', action='store_true')
    ap.add_argument('--rank', action='store_true')
    solve(ap.parse_args())
