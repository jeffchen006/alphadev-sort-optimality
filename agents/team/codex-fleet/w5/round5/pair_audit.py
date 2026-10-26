"""Test pair fusion with exact columns and both comparison operand orders.

This is a necessary-value audit. A witness still needs the full rewrite scan
and the strict judge because intermediate consumers may need the first value.
"""
import json,itertools,sys,time
from pathlib import Path
HERE=Path(__file__).resolve().parent
sys.path.insert(0,str(HERE.parent/'round4/src'))
from flag_audit import trace
ACTIVE={2:(1,),3:(0,1),4:(2,),5:(0,2)}

def synth(entry,flags,d,target):
    if target in entry:return dict(op='mov',dest=d,source=entry.index(target))
    for op,active in ACTIVE.items():
        inactive=[i for i,f in enumerate(flags) if f not in active]
        if any(entry[d][i]!=target[i] for i in inactive):continue
        needed=[i for i,f in enumerate(flags) if f in active]
        for s,col in enumerate(entry):
            if all(col[i]==target[i] for i in needed):return dict(op=['mov','cmp','cmovl','cmovle','cmovg','cmovge'][op],dest=d,source=s)
    return None

began=time.monotonic();rows=[];tested=0;both=0
for row in json.loads((HERE/'manifest.json').read_text()):
    p=row['program'];nr=row['registers']+1;states,_=trace(p,nr)
    writes=[i for i,x in enumerate(p) if x[0]>=2]
    for a,b in itertools.combinations(writes,2):
        tested+=1;entry,_=states[a];first=states[a+1][0][p[a][1]];second=states[b+1][0][p[b][1]]
        # A fused write must leave the first result somewhere, or produce it
        # as the second result. Full consumer repairs are checked separately.
        for flag_source in (a,b):
            flags=states[flag_source][1]
            inverse=bytes(2 if f==1 else 1 if f==2 else f for f in flags)
            orders=[]
            for sign in (flags,inverse):
                feasible=[]
                for d in set((p[a][1],p[b][1])):
                    if first!=second and not any(v==first for r,v in enumerate(entry) if r!=d):continue
                    witness=synth(entry,sign,d,second)
                    if witness:feasible.append(witness)
                orders.append(feasible)
            assert bool(orders[0])==bool(orders[1]),(row['index'],a,b,flag_source)
            if orders[0]:
                both+=1;rows.append(dict(seed=row['index'],pair=[a,b],flag_source=flag_source,forward=orders[0],reverse=orders[1],status='necessary_value_witness_only'))
    if row['index']%24==0:print(json.dumps(dict(seed=row['index'],tested=tested,witnesses=len(rows),seconds=time.monotonic()-began)),flush=True)
result=dict(seeds=144,pairs=tested,flag_choices=2*tested,witnesses=len(rows),both_orders=both,rows=rows,seconds=time.monotonic()-began)
(HERE/'pair_audit.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps({k:v for k,v in result.items() if k!='rows'}),flush=True)
