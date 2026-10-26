"""Compare the SAT transition encoder with the independent scalar evaluator."""
import json, random, time
from pysat.solvers import Solver
from rank_encode import RankEnc
from reference_window import read,OPS,CASES
from analyze import parse,simulate

rng=random.Random(70013);base,_=read('seeds/repair32.s');start=time.monotonic();checked=0
for trial in range(60):
    p=list(base);nr=9
    if trial:
        for _ in range(1+trial%5):
            i=rng.randrange(len(p));p[i]=(rng.randrange(6),rng.randrange(nr),rng.randrange(nr))
    chosen=rng.sample(CASES,10)
    columns={}; goals=list(zip(*(sorted(x) for x in chosen)))
    for t,x in enumerate(chosen):
        code=[(OPS[o],f'P{d}' if d<5 else f'S{d-5}',f'P{s}' if s<5 else f'S{s-5}') for o,d,s in p]
        _,snaps,_=simulate(code,x,garbage=max(x)+1)
        for i,r,v in snaps:columns.setdefault((i,r),[]).append(v)
    expected=all(any(tuple(col)==goal for col in columns.values()) or any(tuple(x[r] for x in chosen)==goal for r in range(5)) for goal in goals)
    e=RankEnc(5,len(p),R=nr,iset='I1',outmode='snap',rules=())
    for i,(o,d,s) in enumerate(p):e.cl(e.op[i][OPS[o]]);e.cl(e.d[i][d]);e.cl(e.s[i][s])
    e.configure(p,[[OPS[o]] for o,d,s in p],[d for o,d,s in p],[s for o,d,s in p])
    for x in chosen:e.add_type(x)
    with Solver(name='cadical195',bootstrap_with=e.clauses) as solver:actual=solver.solve()
    assert actual==expected,(trial,expected,actual)
    checked+=1
print(json.dumps({'fixed_programs_checked':checked,'cases_per_program':10,'seconds':time.monotonic()-start,'status':'MATCH'}))
