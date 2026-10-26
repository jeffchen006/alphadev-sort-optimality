"""Check Boolean/literal identity and regenerate completed query formulas."""
from pathlib import Path
import itertools,json,random,sys,time
HERE=Path(__file__).resolve().parents[2];ROOT=HERE.parents[3]
sys.path[:0]=[str(HERE/'round7/src'),str(HERE/'src'),str(ROOT/'agents/sat')]
from binary_encode import BinaryEnc
from window_sat import read,concrete,GOALS,CASES,OPS
from pysat.solvers import Solver

began=time.monotonic();checks=0
for c,a,b in itertools.product([True,False,1,-1,2,-2,3,-3],repeat=3):
    e=BinaryEnc.__new__(BinaryEnc);e.nvars=3;e.clauses=[];e.cache={};e.boolean_collision_hits=0
    out=e.mux(c,a,b)
    with Solver(name='cadical195',bootstrap_with=e.clauses) as solver:
        for assignment in itertools.product([False,True],repeat=3):
            def v(x):return x if isinstance(x,bool) else assignment[abs(x)-1] if x>0 else not assignment[abs(x)-1]
            assumptions=[i+1 if flag else -i-1 for i,flag in enumerate(assignment)]
            assert solver.solve(assumptions=assumptions)
            model=set(x for x in solver.get_model() if x>0)
            actual=out if isinstance(out,bool) else out in model if out>0 else -out not in model
            assert actual==(v(a) if v(c) else v(b)),(c,a,b,assignment)
            checks+=1

ledger=json.loads(Path('round7/artifacts/query_ledger.json').read_text())
first=json.loads(Path('round6/artifacts/near_inventory.json').read_text())['representatives'][0]['file']
ledger += [dict(source=first,start=12,width=6,typed=typed,name=name,log='round7/logs/'+name+'.log')
           for typed,name in ((True,'t00_w6_i12'),(False,'b00_w6_i12'))]
records=[]
for row in ledger:
    p,nr=read(row['source'])
    e=BinaryEnc(5,len(p),R=nr,iset='I1',outmode='snap',rules=())
    free=set(range(row['start'],row['start']+row['width']))
    domains=[];ds=[];ss=[]
    for i,(op,d,s) in enumerate(p):
        fixed=i not in free
        domain=[OPS[op]] if fixed else ['cmp'] if row['typed'] and op==1 else [o for o in OPS if o!='cmp'] if row['typed'] else OPS
        domains.append(domain);ds.append(d if fixed else None);ss.append(s if fixed else None)
    e.configure(p,domains,ds,ss)
    ev=[]
    for line in Path(row['log']).read_text().splitlines():
        try:ev.append(json.loads(line))
        except ValueError:pass
    starts=[x for x in ev if x.get('step')=='initial_cases']
    if starts:chosen=starts[0]['chosen']
    else:
        cols,_=concrete(p,nr);bad=set()
        for g in GOALS:
            near=min(cols,key=lambda c:sum(x!=y for x,y in zip(c[2],g)))
            bad.update(t for t in range(541) if near[2][t]!=g[t])
        strict=[t for t,x in enumerate(CASES) if len(set(x))==5]
        chosen=sorted(bad|set(random.Random(7201).sample(strict,6)))
    for t in chosen:e.add_type(CASES[t])
    for x in ev:
        if x.get('step')=='candidate':
            for t in x['new_cases']:e.add_type(CASES[t])
    records.append(dict(query=row['name'],boolean_collision_hits=e.boolean_collision_hits,cases=len(e.types)))
    assert e.boolean_collision_hits==0,records[-1]
result=dict(status='MATCH',mux_truth_table_checks=checks,queries=len(records),
            boolean_collision_hits=sum(r['boolean_collision_hits'] for r in records),seconds=time.monotonic()-began,records=records)
Path('round7/artifacts/encoding_audit.json').write_text(json.dumps(result,indent=2))
print(json.dumps({k:v for k,v in result.items() if k!='records'}))
