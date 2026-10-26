"""Independent exhaustive scalar check for the zero/one-instruction schedules."""
import itertools,json,time,random
from pathlib import Path
HERE=Path(__file__).resolve().parent
cases=[w for w in itertools.product(range(5),repeat=5) if set(w)==set(range(max(w)+1))]
rng=random.Random(93410);rng.shuffle(cases);cases.sort(key=lambda w:len(set(w))!=5)
counts=[]
for base in json.loads((HERE/'bases.json').read_text()):
 m=len(base['exclusive']);budget=m-1
 if budget>1:continue
 began=time.process_time();nr=len(base['names'])+2;q=[];exc=set(base['exclusive']);out={int(j):z for j,z in base['outs'].items()}
 for t in range(33):
  for j,(ot,r) in out.items():
   if j!=2 and ot==t:q.append((7,j,r))
  if t<32 and t not in exc:q.append(tuple(base['code'][t]))
 raw=0;case_evals=0;survivors=0
 candidates=[(-1,(6,0,0))] if budget==0 else ((gap,(op,d,s)) for gap in range(len(q)+1) for op in range(6) for d in range(nr) for s in range(nr))
 for gap,instruction in candidates:
  raw+=1;prog=q if gap<0 else q[:gap]+[instruction]+q[gap:];common=None
  for w in cases:
   case_evals+=1;regs=list(w)+[5]*(nr-5);flag=0;goal=sorted(w);mask=0;ok=True;pos=0
   for r in range(nr):
    if regs[r]==goal[2]:mask|=1<<r
   for op,d,s in prog:
    if op==7:
     if regs[s]!=goal[d]:ok=False;break
    else:
     if op==1:flag=(regs[d]>regs[s])-(regs[d]<regs[s])
     elif op==0 or op==2 and flag<0 or op==3 and flag<=0 or op==4 and flag>0 or op==5 and flag>=0:regs[d]=regs[s]
    pos+=1
    for r in range(nr):
     if regs[r]==goal[2]:mask|=1<<(pos*nr+r)
   if not ok:break
   common=mask if common is None else common&mask
   if not common:break
  else:survivors+=1
 row=dict(base=base['id'],budget=budget,raw=raw,case_evaluations=case_evals,survivors=survivors,cpu=time.process_time()-began)
 print('CHECK',row,flush=True);counts.append(row);(HERE/'check_schedule.json').write_text(json.dumps(counts,indent=2)+'\n')
 assert not survivors
