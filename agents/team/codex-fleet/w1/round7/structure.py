"""Describe how the shared computation and median-only writes interact."""
import json
from collections import Counter
from pathlib import Path
from analyze import CASES,OPS,sim
HERE=Path(__file__).resolve().parent
rows=[]
for b in json.loads((HERE/'bases.json').read_text()):
 ex=set(b['exclusive']);core=[tuple(z) for t,z in enumerate(b['code']) if t not in ex];r=len(b['names']);scores=[[0]*r for _ in range(len(core)+1)];losses=Counter();fail=[0]*r
 for w in CASES:
  ss=sim(core,w,r);m=sorted(w)[2]
  loss=next((t for t,st in enumerate(ss) if m not in st),None)
  if loss is not None:losses[loss]+=1
  for t,st in enumerate(ss):
   for rr,v in enumerate(st):scores[t][rr]+=v==m
 best=max((v,t,rr) for t,row in enumerate(scores) for rr,v in enumerate(row));plans=[]
 for t in b['exclusive']:
  op,d,s=b['code'][t];flag=next(z for z in b['code'][:t][::-1] if z[0]==1)
  plans.append(dict(slot=t,op=OPS[op],dest=b['names'][d],source=b['names'][s],comparison=[b['names'][flag[1]],b['names'][flag[2]]]))
 rows.append(dict(base=b['id'],exclusive_count=len(ex),exclusive_plan=plans,retained_k=len(core),best_median_column=dict(correct_cases=best[0],time=best[1],register=b['names'][best[2]]),median_loss_cases=sum(losses.values()),first_loss_times=dict(losses)))
(HERE/'structure.json').write_text(json.dumps(rows,indent=2)+'\n')
for row in rows:print(row['base'],'exclusive',row['exclusive_count'],'best',row['best_median_column'],'lost',row['median_loss_cases'],row['first_loss_times'])
