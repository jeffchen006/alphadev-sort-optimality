"""Check decoded programs from symbolic rank queries on their encoded cases."""
import json
from pathlib import Path
import sys
ROOT = Path(__file__).resolve().parents[6]
sys.path.insert(0,str(ROOT/'agents/sat'))
sys.path.insert(0,str(Path(__file__).resolve().parents[2]/'src'))
from rank_encode import RankEnc
from pysat.solvers import Solver
from window_sat import read, CASES, OPS

p,_ = read('round2/verified/c8_215cbe6f0d1c7837.s')
chosen = [CASES[t] for t in range(0,541,53)]
trials = []
for free in ({0,5,15},{4,9,20},{12,17,28},{21,27,31}):
    e = RankEnc(5,len(p),R=9,iset='I1',outmode='snap',rules=())
    domains,ds,ss,phases = [],[],[],[]
    for i,(o,d,s) in enumerate(p):
        fixed = i not in free
        domains.append([OPS[o]] if fixed else OPS)
        ds.append(d if fixed else None)
        ss.append(s if fixed else None)
        phases += [e.op[i][OPS[o]],e.d[i][d],e.s[i][s]]
        if fixed:
            for lit in phases[-3:]:
                e.cl(lit)
    e.configure(p,domains,ds,ss)
    for case in chosen:
        e.add_type(case)
    with Solver(name='cadical195',bootstrap_with=e.clauses) as solver:
        solver.set_phases(phases)
        assert solver.solve()
        candidate,outmap = e.decode(solver.get_model())
    for case in chosen:
        rs = list(case)+[max(case)+1]*4
        flags = 0
        trace = [rs[:]]
        for op,d,s in candidate:
            if op == 'mov':
                rs[d] = rs[s]
            elif op == 'cmp':
                flags = (rs[d]>rs[s])-(rs[d]<rs[s])
            elif {'cmovl':flags<0,'cmovle':flags<=0,
                  'cmovg':flags>0,'cmovge':flags>=0}[op]:
                rs[d] = rs[s]
            trace.append(rs[:])
        actual = [trace[t][r] for t,r in outmap]
        assert actual == sorted(case), (free,case,actual)
    trials.append({'free':sorted(free),'cases':len(chosen),
                   'variables':e.nvars,'clauses':len(e.clauses),'check':'match'})
print(json.dumps({'symbolic_trials':trials}),flush=True)
