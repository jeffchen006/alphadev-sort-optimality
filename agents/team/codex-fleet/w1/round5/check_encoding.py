"""Positive and negative checks for the new finite encodings.

Run after, not during, another CPU search job.
"""
import itertools
import json
import os
from pathlib import Path
import random
from types import SimpleNamespace

from merge_sat import CASES, PREFIX, Merge, emit, simulate
from rank_chains import data, solve
from rank_dag import Dag

HERE = Path(__file__).resolve().parent


def control():
    prog = [
        (1,0,2),(0,7,0),(4,0,2),(4,2,7),
        (1,1,3),(0,5,1),(4,1,3),(4,3,5),
        (1,1,6),(0,0,6),(2,0,1),(4,6,1),
        (1,6,2),(0,3,2),(2,3,6),(3,6,2),
        (1,0,3),(3,2,0),(4,3,0),
    ]
    normalized = []
    flipped = False
    for op, a, b in prog:
        if op == 1:
            flipped = a > b
            if flipped:
                a, b = b, a
        elif op > 1 and flipped:
            op = {2:4, 3:5, 4:2, 5:3}[op]
        normalized.append((op,a,b))
    outs = [(3,0),(18,2),(19,3),(16,6),(8,3)]
    for w in CASES:
        p, f, _ = simulate(PREFIX, w)
        _, _, snapshots = simulate(normalized, w, (p[:8], f))
        assert [snapshots[t][r] for t,r in outs] == sorted(w)
    emit(HERE/'control34.s', normalized, outs)
    return normalized, outs


def cnf_controls():
    prog, outs = control()
    args = SimpleNamespace(k=19, regs=8, cmps=5, solver='cadical195',creation_outputs=True)
    search = Merge(args)
    # Every input rank and initial comparison orientation occurs in these cases.
    cases = CASES[::7]
    for w in cases:
        search.case(w)
    assumptions = []
    for t, (op,a,b) in enumerate(prog):
        assumptions += [search.ops[t][op],search.dst[t][a],search.src[t][b]]
    assumptions += [search.goals[j][t][r] for j,(t,r) in enumerate(outs)]
    assert search.solver.solve(assumptions=assumptions)
    print('CNF known merge control SAT',len(cases),'cases',flush=True)
    # Require the minimum to equal the known maximum register: this must fail.
    assert not search.solver.solve(assumptions=assumptions + [search.goals[0][8][3]])
    print('CNF wrong output control UNSAT',flush=True)

    rng = random.Random(20261025)
    random_tests = 0
    for test in range(18):
        k, r = 7, 8
        random_prog = []
        for _ in range(k):
            op = rng.randrange(6)
            a, b = rng.randrange(r), rng.randrange(r)
            if op == 1 and a > b:
                a,b = b,a
            random_prog.append((op,a,b))
        search = Merge(SimpleNamespace(k=k,regs=r,cmps=-1,solver='cadical195'))
        # Initial outputs satisfy the sort clauses for this single case.
        # Additional output requirements query individual transition values.
        w = rng.choice([w for w in CASES if len(set(w)) == 5])
        search.case(w)
        p,f,_ = simulate(PREFIX,w)
        _,_,snapshots = simulate(random_prog,w,(p[:r],f))
        assumptions = [v for t,(op,a,b) in enumerate(random_prog)
                       for v in (search.ops[t][op],search.dst[t][a],search.src[t][b])]
        assumptions += [search.goals[j][0][next(i for i,v in enumerate(p[:r]) if v==j)]
                        for j in range(5)]
        assert search.solver.solve(assumptions=assumptions)
        for _ in range(16):
            t,a = rng.randrange(k+1),rng.randrange(r)
            value = snapshots[t][a]
            assert search.solver.solve(assumptions=assumptions+[search.goals[value][t][a]])
            assert not search.solver.solve(assumptions=assumptions+[search.goals[(value+1)%5][t][a]])
            random_tests += 1
    print('CNF random transition value pairs checked',random_tests,flush=True)


def chain_trace_checks():
    cases, cols, goals = data()
    pairs = [(i,j) for i in range(2) for j in range(2,5)]
    checked = 0
    for order in itertools.permutations(pairs):
        costs, traces, _ = solve(order,cases,cols,goals,True)
        for j,(cost,(init,trace)) in enumerate(zip(costs,traces)):
            if cost >= 99:
                continue
            assert len(trace) == cost
            for w,goal in zip(cases,goals[j]):
                acc = w[init]
                for t,c,s in trace:
                    a,b = order[t]
                    q = (w[a] > w[b]) - (w[a] < w[b])
                    if [q<0,q<=0,q>0,q>=0][c]:
                        acc = w[s]
                assert acc == goal,(order,j,w,trace)
            checked += 1
    print('Raw-chain scalar checks',checked,'valid output chains on',len(cases),'weak orders',flush=True)


def dag_controls():
    cases, cols, goals = data()
    pairs = [(i,j) for i in range(2) for j in range(2,5)]
    order = (pairs[0],pairs[1],pairs[2],pairs[5],pairs[4],pairs[3])
    costs, traces, _ = solve(order,cases,cols,goals,True)
    assert costs == [1,3,4,3,1]
    current = [init for init, trace in traces]
    gates = []
    for block in range(6):
        for j, (init, trace) in enumerate(traces):
            for t,c,src in trace:
                if t == block:
                    a,b = current[j],src
                    if a > b:
                        a,b = b,a
                        c = {0:3,1:2,2:1,3:0}[c]
                    gates.append((a,b,block,c))
                    current[j] = len(gates)+4
    plan = {'order': [pairs.index(p) for p in order], 'gates': gates, 'out': current}
    search = Dag(SimpleNamespace(gates=12, solver='cadical195'))
    for w in cases:
        assert search.evaluate(plan,w) == sorted(w)
        search.case(w)
    assumptions = [search.order[b][p] for b,p in enumerate(plan['order'])]
    for i,(a,b,block,c) in enumerate(gates):
        assumptions += [search.a[i][a],search.b[i][b],search.block[i][block],search.cnd[i][c]]
    fixed = list(assumptions)
    assumptions += [search.out[j][s] for j,s in enumerate(current)]
    assert search.solver.solve(assumptions=assumptions)
    print('Shared DAG known 12-gate control SAT',len(cases),'weak orders',flush=True)
    wrong = [search.out[0][current[4]]]+[search.out[j][current[j]] for j in range(1,5)]
    assert not search.solver.solve(assumptions=fixed+wrong)
    print('Shared DAG wrong-output control UNSAT',flush=True)
    (HERE/'rank_dag12_control.json').write_text(json.dumps(plan,indent=2)+'\n')
    normalized={**plan,'gates':[(a,b,bl,0 if c==1 else 2 if c==3 else c)
                               for a,b,bl,c in plan['gates']]}
    strict=Dag(SimpleNamespace(gates=12,solver='cadical195'))
    for cnd in strict.cnd:
        strict.add(-cnd[1]);strict.add(-cnd[3])
    for w in cases:
        if len(set(w))==5:
            assert strict.evaluate(normalized,w)==sorted(w)
            strict.case(w)
    assumptions=[strict.order[b][p] for b,p in enumerate(normalized['order'])]
    for i,(a,b,bl,c) in enumerate(normalized['gates']):
        assumptions += [strict.a[i][a],strict.b[i][b],strict.block[i][bl],strict.cnd[i][c]]
    assumptions += [strict.out[j][s] for j,s in enumerate(current)]
    assert strict.solver.solve(assumptions=assumptions)
    print('Normalized raw-condition 12-gate control SAT',len(strict.used),'strict interleavings',flush=True)


def binary_controls():
    # Select each comparison operand from c/e using the first two flags.
    prog=[(1,0,6),(0,7,3),(2,7,2),(1,1,6),(0,5,3),(2,5,2),(1,0,7),(1,1,5)]
    cases,_,_=data()
    count=0
    for w in cases:
        args=SimpleNamespace(k=8,regs=8,cmps=4,solver='cadical195',
                             fixed='binary',prefix='pair')
        search=Merge(args)
        search.case(w)
        assumptions=[v for t,(op,a,b) in enumerate(prog)
                     for v in (search.ops[t][op],search.dst[t][a],search.src[t][b])]
        assumptions += [-v for v in search.flip]
        assert search.solver.solve(assumptions=assumptions),w
        p,_,_=simulate(PREFIX,w)
        if p[0] != (p[2] if p[0]<p[6] else p[3]):
            wrong=assumptions[:-4]+[-search.flip[0],-search.flip[1],search.flip[2],-search.flip[3]]
            assert not search.solver.solve(assumptions=wrong)
        count+=1
    print('Fixed binary-comparison controls SAT',count,'weak orders; reversed-flag checks UNSAT',flush=True)

    # Interleave each insertion comparison immediately after its operand
    # selection. Also test the triple-only prefix with an integrated pair.
    for prefix,regs in [('pair',8),('triple',7)]:
        pair_prog=[]
        x=7
        if prefix=='triple':
            pair_prog=[(1,0,1),(0,5,0),(4,0,1),(4,1,5)]
            x=4
        prog=pair_prog+[(1,0,6),(0,x,3),(2,x,2),(1,0,x),
                        (1,1,6),(0,5,3),(2,5,2),(1,1,5)]
        cases,_,_=data((1,1,3) if prefix=='triple' else (2,3))
        for w in cases:
            args=SimpleNamespace(k=len(prog),regs=regs,cmps=5 if pair_prog else 4,
                                 solver='cadical195',fixed='binary',prefix=prefix,
                                 predicate_order='0,2,1,3')
            search=Merge(args)
            search.case(w)
            assumptions=[v for t,(op,a,b) in enumerate(prog)
                         for v in (search.ops[t][op],search.dst[t][a],search.src[t][b])]
            assumptions += [-v for v in search.flip]
            assert search.solver.solve(assumptions=assumptions),(prefix,w)
        print('Interleaved binary-comparison controls SAT',prefix,len(cases),'weak orders',flush=True)


def fresh_controls():
    count=0
    for w in CASES[::11]:
        args=SimpleNamespace(k=3,regs=8,cmps=1,solver='cadical195',prefix='triple')
        search=Merge(args)
        search.case(w)
        # A conditional copy to a fresh register can feed another write on
        # the same selected cases. It cannot feed a comparison on other cases.
        prog=[(2,7,0),(2,4,7),(1,0,7)]
        assumptions=[v for t,(op,a,b) in enumerate(prog)
                     for v in (search.ops[t][op],search.dst[t][a],search.src[t][b])]
        _,flag,_=simulate(PREFIX[:11],w)
        assert search.solver.solve(assumptions=assumptions)==bool(flag[0])
        # Unconditional initialization of the fresh destination always works.
        assumptions=[v for t,(op,a,b) in enumerate([(0,7,0),(0,4,7),(1,0,7)])
                     for v in (search.ops[t][op],search.dst[t][a],search.src[t][b])]
        assert search.solver.solve(assumptions=assumptions)
        count+=1
    print('Fresh-register initialization and comparison guards checked',count,'weak orders',flush=True)


if __name__ == '__main__':
    os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
    cnf_controls()
    chain_trace_checks()
    dag_controls()
    binary_controls()
    fresh_controls()
    print('COMPLETE encoding controls',flush=True)
