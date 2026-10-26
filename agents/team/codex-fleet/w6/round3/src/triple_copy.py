"""Try a duplicate-minimum triple prefix, then judge the full k=31 program."""
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
from window_sat import read,OPS,reg,concrete,GOALS

nr = int(sys.argv[1]) if len(sys.argv)>1 else 5
e = RankEnc(3,11,R=nr,iset='I1',outmode='snap',rules=())
domains = [['mov'] if i == 0 else ['cmp'] if i in (1,5,8)
           else [name for name in OPS if name != 'cmp'] for i in range(11)]
for i,domain in enumerate(domains):
    e.cl(*[e.op[i][name] for name in domain])
e.configure([],domains,[None]*11,[None]*11)
e.final_targets = [(0,0),(1,0),(3,2),(4,1)]
for case in itertools.product(range(3),repeat=3):
    if set(case) == set(range(max(case)+1)):
        e.add_type(case)
print(json.dumps({'registers':nr,'cases':len(e.types),'variables':e.nvars,
                  'clauses':len(e.clauses)}),flush=True)
with Solver(name='cadical195',bootstrap_with=e.clauses) as solver:
    for it in itertools.count():
        if not solver.solve():
            print(json.dumps({'status':'UNSAT','iteration':it}),flush=True)
            break
        triple,_ = e.decode(solver.get_model())
        print(json.dumps({'status':'SAT','program':triple,'iteration':it}),flush=True)
        p,n = read('round2/candidates/near14_frozen.s')
        slots = [3,5,6,7,8,9,10,11,12,13,14]
        mapping = {0:1,1:2,2:3,3:6,4:7}
        for r in range(5,nr):
            mapping[r] = r+3
        for i,(op,d,s) in zip(slots,triple):
            p[i] = (OPS.index(op),mapping[d],mapping[s])
        cols,_ = concrete(p,max(n-1,max(mapping.values())+1))
        witnesses = []
        for goal in GOALS:
            exact = [(t,r) for t,r,col in cols if col == goal]
            witnesses.append(exact[0] if exact else None)
        if all(w is not None for w in witnesses):
            from satrep import emit
            path = Path(f'round3/candidates/triple_copy_R{nr}.s')
            emit(p,witnesses,path)
            log = Path(f'round3/logs/triple_copy_R{nr}_judge.log')
            with log.open('w') as f:
                result = subprocess.run(['nice','-n','19','python3','-B',str(ROOT/'shared/judge.py'),
                    str(path),'--strict','--model','out'],stdout=f,stderr=subprocess.STDOUT)
            if result.returncode == 0 and 'PASS ' in log.read_text():
                Path('round3/artifacts/FOUND_PENDING').write_text(str(path)+'\n')
                print(json.dumps({'status':'CANDIDATE','file':str(path)}),flush=True)
                break
        solver.add_clause([-v for i,(op,d,s) in enumerate(triple)
                           for v in (e.op[i][op],e.d[i][d],e.s[i][s])])
