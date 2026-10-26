"""Synthesize an 11-instruction triple sort with two copies of its minimum."""
import argparse
import itertools
import json
from pathlib import Path
import subprocess
import sys
ROOT = Path(__file__).resolve().parents[6]
sys.path.insert(0,str(ROOT/'agents/sat'))
sys.path.insert(0,str(Path(__file__).resolve().parents[2]/'src'))
from rank_encode import RankEnc
from pysat.solvers import Solver
from pysat.card import CardEnc,EncType
from window_sat import read,concrete,GOALS,OPS

ap = argparse.ArgumentParser()
ap.add_argument('--registers',type=int,default=5)
ap.add_argument('--control',action='store_true')
a = ap.parse_args()
nr = a.registers
control = [('mov',3,0),('cmp',1,2),('cmovle',4,2),('cmovg',4,1),
           ('cmovl',2,1),('cmp',0,2),('cmovge',0,2),('cmovge',2,3),
           ('cmp',2,4),('cmovle',3,4),('cmovl',4,2),('mov',1,0)]
k = 12 if a.control else 11
e = RankEnc(3,k,R=nr,iset='I1',outmode='snap',rules=())
if a.control:
    for i,(op,d,s) in enumerate(control):
        e.cl(e.op[i][op]);e.cl(e.d[i][d]);e.cl(e.s[i][s])
    e.configure([],[[op] for op,d,s in control],
                [d for op,d,s in control],[s for op,d,s in control])
    e.final_targets = [(0,0),(1,0),(3,2),(4,1)]
else:
    e.configure([], [OPS]*k,[None]*k,[None]*k)
    cmpvars = [e.op[i]['cmp'] for i in range(k)]
    for method,bound in ((CardEnc.atleast,3),(CardEnc.atmost,4)):
        card = method(cmpvars,bound,top_id=e.nvars,encoding=EncType.seqcounter)
        e.nvars = card.nv;e.clauses.extend(card.clauses)
    targets = [[e.new() for r in range(nr)] for j in range(4)]
    for row in targets:
        e.exactly_one(row)
    for r in range(nr):
        for j in range(4):
            for z in range(j):
                e.cl(-targets[j][r],-targets[z][r])
    for r in range(nr):
        for s in range(r+1):
            e.cl(-targets[0][r],-targets[1][s])
    e.role_targets = [(goal,row) for goal,row in zip((0,0,1,2),targets)]
for case in itertools.product(range(3),repeat=3):
    if set(case) == set(range(max(case)+1)):
        e.add_type(case)
print(json.dumps({'k':k,'registers':nr,'cases':len(e.types),
                  'variables':e.nvars,'clauses':len(e.clauses)}),flush=True)
with Solver(name='cadical195',bootstrap_with=e.clauses) as solver:
    for it in itertools.count():
        if not solver.solve():
            print(json.dumps({'status':'UNSAT','iteration':it}),flush=True)
            break
        model = solver.get_model()
        triple,_ = e.decode(model)
        if a.control:
            print(json.dumps({'status':'CONTROL_SAT','program':triple}),flush=True)
            break
        modelset = set(model)
        roles = [next(r for r in range(nr) if row[r] in modelset) for row in targets]
        print(json.dumps({'status':'SAT','roles':roles,'program':triple,'iteration':it}),flush=True)
        original,n = read('round2/candidates/near14_frozen.s')
        mapping = {0:1,1:2,2:3,3:6,4:7}
        for r in range(5,nr):
            mapping[r] = r+3
        suffixmap = dict(zip((1,2,7,6),[mapping[r] for r in roles]))
        prefix = original[:3]+[original[4]]
        body = [(OPS.index(op),mapping[d],mapping[s]) for op,d,s in triple]
        suffix = [(op,suffixmap.get(d,d),suffixmap.get(s,s)) for op,d,s in original[15:]]
        p = prefix+body+suffix
        cols,_ = concrete(p,max(n-1,max(mapping.values())+1))
        witnesses = []
        for goal in GOALS:
            exact = [(t,r) for t,r,col in cols if col == goal]
            witnesses.append(exact[0] if exact else None)
        if all(w is not None for w in witnesses):
            from satrep import emit
            path = Path(f'round3/candidates/triple_free_R{nr}.s')
            emit(p,witnesses,path)
            log = Path(f'round3/logs/triple_free_R{nr}_judge.log')
            with log.open('w') as f:
                result = subprocess.run(['nice','-n','19','python3','-B',str(ROOT/'shared/judge.py'),
                    str(path),'--strict','--model','out'],stdout=f,stderr=subprocess.STDOUT)
            if result.returncode == 0 and 'PASS ' in log.read_text():
                Path('round3/artifacts/FOUND_PENDING').write_text(str(path)+'\n')
                print(json.dumps({'status':'CANDIDATE','file':str(path)}),flush=True)
                break
        solver.add_clause([-v for i,(op,d,s) in enumerate(triple)
                           for v in (e.op[i][op],e.d[i][d],e.s[i][s])]+[-targets[j][r] for j,r in enumerate(roles)])
