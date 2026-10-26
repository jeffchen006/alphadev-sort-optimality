"""Compare symbolic gate traces with scalar execution on fixed instructions."""
from pathlib import Path
import json,random,sys,time
HERE=Path(__file__).resolve().parents[2];ROOT=HERE.parents[3]
sys.path[:0]=[str(HERE/'round7/src'),str(HERE/'src'),str(ROOT/'agents/sat')]
from binary_encode import BinaryEnc
from window_sat import read,OPS,CASES
from pysat.solvers import Solver

rnd=random.Random(72019);began=time.monotonic();counts=dict(programs=0,cases=0,register_values=0,flags=0)
rows=json.loads((HERE/'round6/artifacts/near_inventory.json').read_text())['representatives']
for row in rows:
    base,nr=read(HERE/row['file']);nr+=1
    for variant in range(6):
        p=base[:];start=rnd.randrange(24);width=rnd.choice([6,7,8])
        for _ in range(variant):
            i=rnd.randrange(start,min(start+width,len(p)))
            p[i]=(rnd.randrange(6),rnd.randrange(nr),rnd.randrange(nr))
        e=BinaryEnc(5,len(p),R=nr,iset='I1',outmode='snap',rules=())
        domains=[OPS if start<=i<start+width else [OPS[op]] for i,(op,d,s) in enumerate(p)]
        ds=[None if start<=i<start+width else d for i,(_,d,_) in enumerate(p)]
        ss=[None if start<=i<start+width else s for i,(_,_,s) in enumerate(p)]
        e.configure(p,domains,ds,ss);e.check_only=True
        cases=[CASES[i] for i in rnd.sample(range(541),6)]
        traces=[]
        for case in cases:e.add_type(case);traces.append(e.last_trace)
        for i,(op,d,s) in enumerate(p):
            e.cl(e.op[i][OPS[op]]);e.cl(e.d[i][d]);e.cl(e.s[i][s])
        with Solver(name='cadical195',bootstrap_with=e.clauses) as solver:
            assert solver.solve()
            model={v for v in solver.get_model() if v>0}
        def bit(v):return v if isinstance(v,bool) else (v in model if v>0 else -v not in model)
        for case,trace in zip(cases,traces):
            vals=list(case)+[5]*(nr-5);fl=0
            for step,((op,d,s),(rs,lt,gt)) in enumerate(zip(p,trace)):
                if op==0:vals[d]=vals[s]
                elif op==1:fl=(vals[d]>vals[s])-(vals[d]<vals[s])
                elif (fl<0 if op==2 else fl<=0 if op==3 else fl>0 if op==4 else fl>=0):vals[d]=vals[s]
                actual=[sum(int(bit(v))<<b for b,v in enumerate(r)) for r in rs]
                assert actual==vals,(row['file'],variant,case,actual,vals)
                # The final flag state is intentionally unused and is not encoded.
                if step+1<len(p):
                    assert bit(lt)==(fl<0) and bit(gt)==(fl>0)
                    counts['flags']+=2
                counts['register_values']+=nr
            counts['cases']+=1
        counts['programs']+=1
counts.update(seconds=time.monotonic()-began,status='MATCH')
print(json.dumps(counts))
