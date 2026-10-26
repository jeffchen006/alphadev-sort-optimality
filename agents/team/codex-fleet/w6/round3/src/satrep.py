"""CEGIS repair with free comparison operands and free conditional moves.

The SAT encoder has a relaxed initial state. Full candidate validation uses
the conservative independent evaluator. Only the strict judge authorizes PASS.
"""
import argparse
import itertools
import json
from pathlib import Path
import random
import subprocess
import sys
import time

HERE = Path(__file__).resolve().parents[2]
ROOT = HERE.parents[3]
sys.path.insert(0, str(ROOT / 'agents/sat'))
sys.path.insert(0, str(HERE / 'src'))
from encode import Enc
from pysat.card import CardEnc, EncType
from pysat.solvers import Solver
from window_sat import read, concrete, reg, OPS, CASES, GOALS
from rank_encode import RankEnc


def emit(p, witnesses, path):
    body = [f'# n=5 model=out iset=I1 source=w6-round3-satrep k={len(p)}']
    for j, (t, r) in enumerate(witnesses):
        if t == -1:
            body.append(f'out {j}, {reg(r)}')
    for t, (op, d, s) in enumerate(p):
        body.append(f'{OPS[op]} {reg(d)}, {reg(s)}')
        for j, (when, r) in enumerate(witnesses):
            if when == t:
                body.append(f'out {j}, {reg(r)}')
    Path(path).write_text('\n'.join(body)+'\n')


def solve(a):
    began = time.monotonic()
    p, nr = read(a.seed)
    nr = nr - 1 + a.fresh
    if a.delete >= 0:
        del p[a.delete]
    k = len(p)
    e = (RankEnc if a.rank else Enc)(5, k, R=nr, iset='I1', outmode='snap', rules=())
    if a.fixed_outputs:
        registers = {f'P{r}':r for r in range(5)}
        position = 0
        for line in Path(a.seed).read_text().splitlines():
            line = line.split('#')[0].strip()
            if not line:
                continue
            op,d,s = line.replace(',','').split()
            if op == 'out':
                when = position - (a.delete >= 0 and position > a.delete)
                r = registers[s]
                if when == 0:
                    assert r < 5
                    e.cl(e.osnap[int(d)][r])
                else:
                    e.cl(e.osnap[int(d)][5+when-1])
                    e.cl(e.d[when-1][r])
                continue
            for r in (d,s):
                if r not in registers:
                    registers[r] = len(registers)
            position += 1
    changes, cmpchanges, phases = [], [], []
    free = set(map(int, a.free.split(','))) if a.free else set(range(k))
    domains, destinations, sources = [], [], []
    for i, (op, d, s) in enumerate(p):
        fixed = i < a.prefix or i not in free or a.control
        domains.append([OPS[op]] if fixed else
                       ['cmp'] if a.typed and op == 1 else
                       [name for name in OPS if name != 'cmp'] if a.typed else OPS)
        destinations.append(d if fixed or (a.fixed_dest and op != 1) else None)
        sources.append(s if fixed else None)
        if a.typed:
            if op == 1:
                e.cl(e.op[i]['cmp'])
            else:
                e.cl(*[e.op[i][name] for name in OPS if name != 'cmp'])
        if a.fixed_dest and op != 1:
            e.cl(e.d[i][d])
        ch = e.new()
        for literal in (e.op[i][OPS[op]], e.d[i][d], e.s[i][s]):
            e.cl(ch, literal)
        changes.append(ch)
        if op == 1:
            cmpchanges.append(ch)
        phases.extend((e.op[i][OPS[op]], e.d[i][d], e.s[i][s], -ch))
        if fixed:
            e.cl(-ch)
    if a.rank:
        e.configure(p, domains, destinations, sources)
    if not a.control:
        if a.changes:
            card = CardEnc.atmost(changes, a.changes, top_id=e.nvars,
                                 encoding=EncType.seqcounter)
            e.nvars = card.nv
            e.clauses.extend(card.clauses)
        if a.change_cmp:
            # ch -> some part of the comparison differs.
            for i, (op, d, s) in enumerate(p):
                if op == 1:
                    e.cl(-changes[i], -e.op[i]['cmp'], -e.d[i][d], -e.s[i][s])
            e.cl(*cmpchanges)
    if a.maxcmp:
        card = CardEnc.atmost([e.op[i]['cmp'] for i in range(k)], a.maxcmp,
                             top_id=e.nvars, encoding=EncType.seqcounter)
        e.nvars = card.nv
        e.clauses.extend(card.clauses)
    rnd = random.Random(a.random_seed)
    strict = [t for t, x in enumerate(CASES) if len(set(x)) == 5]
    chosen = set(rnd.sample(strict, a.strict_types))
    cols, _ = concrete(p, nr)
    bad = set()
    for j, goal in enumerate(GOALS):
        _, _, col = min(cols, key=lambda x: sum(a0 != b0 for a0, b0 in zip(x[2], goal)))
        bad.update(t for t in range(541) if col[t] != goal[t])
    if bad:
        chosen.update(rnd.sample(sorted(bad), min(a.bad_types, len(bad))))
    else:
        chosen.update(rnd.sample(range(541), a.bad_types))
    for t in sorted(chosen):
        e.add_type(CASES[t])
    with Solver(name=a.solver) as solver:
        solver.set_phases(phases)
        pushed = 0
        best_near = (14,18)
        for it in itertools.count():
            for clause in e.clauses[pushed:]:
                solver.add_clause(clause)
            pushed = len(e.clauses)
            print(json.dumps({'step':'solve', 'iteration':it, 'cases':len(chosen),
                              'variables':e.nvars, 'clauses':pushed,
                              'seconds':time.monotonic()-began}), flush=True)
            if not solver.solve():
                print(json.dumps({'status':'UNSAT', 'cases':len(chosen),
                                  'seconds':time.monotonic()-began}), flush=True)
                return
            candidate, outmap = e.decode(solver.get_model())
            q = [(OPS.index(op), d, s) for op, d, s in candidate]
            cols, _ = concrete(q, nr)
            witnesses, nearest, nearest_columns, added, best_errors = [], [], [], set(), []
            for j, goal in enumerate(GOALS):
                exact = [(t,r) for t,r,col in cols if col == goal]
                witnesses.append(exact[0] if exact else None)
                best_errors.append(min(sum(x != y for x,y in zip(col,goal)) for _,_,col in cols))
                bt,br,bc = min(cols,key=lambda x:sum(v != g for v,g in zip(x[2],goal)))
                nearest.append((bt,br))
                nearest_columns.append(bc)
                eligible = [col for _,_,col in cols
                            if all(col[t] == goal[t] for t in chosen)]
                # Add up to four cases per output. Prefer a case that excludes
                # the largest number of surviving snapshot choices.
                for _ in range(4):
                    if not eligible or exact:
                        break
                    counts = {t:sum(col[t] != goal[t] for col in eligible)
                              for t in range(541) if t not in chosen | added}
                    if not counts or max(counts.values()) == 0:
                        break
                    t = max(counts, key=counts.get)
                    added.add(t)
                    eligible = [col for col in eligible if col[t] == goal[t]]
            print(json.dumps({'step':'candidate', 'iteration':it,
                              'errors':best_errors, 'new_cases':sorted(added)}), flush=True)
            failed = sum(any(nearest_columns[j][t] != GOALS[j][t] for j in range(5))
                         for t in range(541))
            if (failed,sum(best_errors)) < best_near:
                best_near = (failed,sum(best_errors))
                near = str(Path(a.output).with_suffix(''))+'_near.s'
                emit(q,nearest,near)
                print(json.dumps({'step':'NEAR','file':near,'failed_orders':failed,
                                  'output_error_sum':sum(best_errors)}),flush=True)
            if all(w is not None for w in witnesses):
                emit(q, witnesses, a.output)
                print(json.dumps({'status':'CANDIDATE', 'file':a.output,
                                  'seconds':time.monotonic()-began}), flush=True)
                return
            if not added:
                # The conservative evaluator can lose correlations between
                # unknown scratch values. Ask the strict judge before blocking
                # a program that the relaxed solver accepts on all added cases.
                emit(q, [(when-1,r) for when,r in outmap], a.output)
                log = Path(a.output).with_suffix('.rescue_judge.log')
                with log.open('w') as stream:
                    result = subprocess.run(['nice','-n','19','python3','-B',
                        str(ROOT/'shared/judge.py'),a.output,'--strict','--model','out'],
                        stdout=stream,stderr=subprocess.STDOUT)
                if result.returncode == 0 and 'PASS ' in log.read_text():
                    print(json.dumps({'status':'CANDIDATE','file':a.output,
                                      'strict_rescue':True}),flush=True)
                    return
                Path(a.output).unlink()
                e.cl(*[-v for i,(op,d,s) in enumerate(q)
                       for v in (e.op[i][OPS[op]], e.d[i][d], e.s[i][s])])
            for t in sorted(added):
                e.add_type(CASES[t])
            chosen |= added


if __name__ == '__main__':
    ap = argparse.ArgumentParser()
    ap.add_argument('seed')
    ap.add_argument('output')
    ap.add_argument('--delete', type=int, default=-1)
    ap.add_argument('--changes', type=int, default=4)
    ap.add_argument('--prefix', type=int, default=0)
    ap.add_argument('--fresh', type=int, default=0)
    ap.add_argument('--typed', action='store_true')
    ap.add_argument('--fixed-dest', action='store_true')
    ap.add_argument('--control', action='store_true')
    ap.add_argument('--change-cmp', action='store_true')
    ap.add_argument('--free', default='')
    ap.add_argument('--maxcmp', type=int, default=8)
    ap.add_argument('--strict-types', type=int, default=8)
    ap.add_argument('--bad-types', type=int, default=6)
    ap.add_argument('--random-seed', type=int, default=8301)
    ap.add_argument('--solver', default='cadical195')
    ap.add_argument('--rank', action='store_true')
    ap.add_argument('--fixed-outputs', action='store_true')
    solve(ap.parse_args())
