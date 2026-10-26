"""Compare the two encoders on fixed correct and incorrect programs."""
import json
from pathlib import Path
import random
import sys
ROOT = Path(__file__).resolve().parents[6]
sys.path.insert(0,str(ROOT/'agents/sat'))
sys.path.insert(0,str(Path(__file__).resolve().parents[2]/'src'))
from encode import Enc
from rank_encode import RankEnc
from pysat.solvers import Solver
from window_sat import read, CASES, OPS

seed,_ = read('round2/verified/c8_215cbe6f0d1c7837.s')
randomizer = random.Random(8531)
rows = []
for n in range(12):
    p = list(seed)
    if n:
        for _ in range(1+n%3):
            i = randomizer.randrange(len(p))
            op,d,s = p[i]
            edit = randomizer.randrange(3)
            p[i] = (randomizer.randrange(6) if edit == 0 else op,
                    randomizer.randrange(9) if edit == 1 else d,
                    randomizer.randrange(9) if edit == 2 else s)
    statuses = []
    for encoder in (Enc, RankEnc):
        e = encoder(5,len(p),R=9,iset='I1',outmode='snap',rules=())
        if isinstance(e,RankEnc):
            e.configure(p,[[OPS[o]] for o,d,s in p],
                        [d for o,d,s in p],[s for o,d,s in p])
        for i,(o,d,s) in enumerate(p):
            e.cl(e.op[i][OPS[o]])
            e.cl(e.d[i][d])
            e.cl(e.s[i][s])
        for t in range(0,541,43):
            e.add_type(CASES[t])
        with Solver(name='cadical195',bootstrap_with=e.clauses) as solver:
            status = solver.solve()
        statuses.append(status)
    assert statuses[0] == statuses[1], (n,statuses,p)
    if n == 0:
        assert all(statuses)
    rows.append({'trial':n,'SAT':statuses[0]})
print(json.dumps({'encoder_comparisons':rows}),flush=True)
