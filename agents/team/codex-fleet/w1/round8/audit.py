"""Check both output selectors against independent scalar snapshot columns."""
import itertools,json,os,resource
from pathlib import Path
from synth import Synth
from fast_synth import Synth as FastSynth
HERE=Path(__file__).resolve().parent
os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
if os.getpriority(os.PRIO_PROCESS,0)<19:os.nice(19-os.getpriority(os.PRIO_PROCESS,0))
resource.setrlimit(resource.RLIMIT_AS,(2800*1024**2,2800*1024**2))
def snapshots(code,w,r):
 regs=list(w)+[5]*(r-5);flag=0;rows=[tuple(regs)]
 for op,d,src in code:
  if op==1:flag=-1 if regs[d]<regs[src] else 1 if regs[d]>regs[src] else 0
  elif op==0 or (op==2 and flag<0) or (op==3 and flag<=0) or (op==4 and flag>0) or (op==5 and flag>=0):regs[d]=regs[src]
  rows.append(tuple(regs))
 return rows
allcases=[w for w in itertools.product(range(5),repeat=5) if set(w)==set(range(max(w)+1))]
bases=json.loads((HERE/'bases.json').read_text());rows=[]
for bi,engine,editable_mode in itertools.product((0,1,20,21,30,31,32,33),(Synth,FastSynth),('fixed','pinned')):
 b=bases[bi];seed=allcases[::37]+[(0,1,2,3,4),(4,3,2,1,0)]
 if b['kind']=='near':
  near=json.loads((HERE.parent/'round6/analysis.json').read_text())[b['id']]
  seed=list(dict.fromkeys(seed+[tuple(f['input']) for f in near['failures']]))
 s=engine(b,[] if editable_mode=='fixed' else b['exclusive'],extra=2,drop=0,free_outputs=b['free_outputs'])
 for t,(o,d,src) in s.choice.items():
  op,a,z=b['code'][t];s.add(o[op]);s.add(d[a]);s.add(src[z])
 for w in seed:s.case(w)
 ss=[snapshots(b['code'],w,s.r) for w in seed]
 masks={j:[(t,r) for t in range(len(b['code'])+1) for r in range(s.r)
  if all(st[t][r]==sorted(w)[j] for w,st in zip(seed,ss))] for j in b['free_outputs']}
 fixed_ok=all(st[t][r]==sorted(w)[int(j)] for w,st in zip(seed,ss)
  for j,(t,r) in b['outs'].items() if int(j) not in b['free_outputs'])
 possible=fixed_ok and all(masks.values())
 assert s.solver.solve()==possible,(bi,'overall')
 count=0
 for j,goal in s.goals.items():
  for t,row in enumerate(goal):
   for r,lit in enumerate(row):
    expected=possible and (t,r) in masks[j]
    assert s.solver.solve(assumptions=[lit])==expected,(bi,j,t,r)
    count+=1
 s.solver.delete();rows.append(dict(index=bi,key=b['key'],engine=engine.__module__,mode=editable_mode,cases=len(seed),selector_checks=count,possible=possible,
  valid_columns={j:len(v) for j,v in masks.items()}))
 print('AUDIT',rows[-1],flush=True)
(HERE/'audit.json').write_text(json.dumps(dict(status='PASS_OUTPUT_SELECTOR_AUDIT',records=rows),indent=2)+'\n')
