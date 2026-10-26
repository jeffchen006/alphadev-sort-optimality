"""Move median-only computations to any gap in the retained event stream."""
import argparse,json,os,resource,time
from pathlib import Path
from pysat.card import CardEnc,EncType
from synth import Synth
HERE=Path(__file__).resolve().parent
ap=argparse.ArgumentParser();ap.add_argument('--cpu',type=float,default=60);ap.add_argument('--start',type=int,default=0);ap.add_argument('--end',type=int,default=16);ap.add_argument('--extra',type=int,default=2);ap.add_argument('--control',action='store_true');args=ap.parse_args()
os.sched_setaffinity(0,{min(os.sched_getaffinity(0))});resource.setrlimit(resource.RLIMIT_AS,(2800*1024**2,2800*1024**2))
rows=[];stem='schedule'+('_control' if args.control else '')+f'_r{args.extra}'
if args.start!=0 or args.end!=16:stem+=f'_b{args.start}_{args.end}'
for original in json.loads((HERE/'bases.json').read_text())[args.start:args.end]:
 began=time.process_time();base=dict(original);exc=set(base['exclusive']);budget=len(exc)-(0 if args.control else 1)
 events=[]
 for t in range(33):
  for j,(ot,r) in original['outs'].items():
   if int(j)!=2 and ot==t:events.append(('out',int(j),r,t))
  if t<32 and t not in exc:events.append(('core',*original['code'][t],t))
 q=[];editable=[];outs={};groups=[];pins={};pending=sorted(exc)
 for event in events+[('end',32)]:
  group=[]
  for i in range(budget):
   group.append(len(q));editable.append(len(q));q.append((6,0,0))
  groups.append(group)
  if args.control:
   selected=[t for t in pending if t<event[-1]]
   assert len(selected)<=len(group)
   for n,t in enumerate(group):pins[t]=tuple(original['code'][selected[n]]) if n<len(selected) else (6,0,0)
   pending=[t for t in pending if t not in selected]
  if event[0]=='out':outs[str(event[1])]=(len(q),event[2])
  elif event[0]=='core':q.append(event[1:4])
 base['code']=q;base['outs']=outs
 # drop = number of NOPs needed to leave at most the specified new instructions.
 s=Synth(base,editable,args.extra,drop=len(editable)-budget)
 if args.control:
  assert not pending
  for t,(op,a,b) in pins.items():
   o,d,src=s.choice[t];s.add(o[op]);s.add(d[a]);s.add(src[b])
 # Two writes in one gap can be moved into the first two optional positions.
 for group in groups:
  for a,b in zip(group,group[1:]):s.add(s.choice[b][0][6],-s.choice[a][0][6])
 res=s.run(args.cpu);res.update(used_cases=s.used,base=base['id'],budget=budget,exclusive=original['exclusive'],editable=editable,args=vars(args),vars=s.pool.top,clauses=s.clauses,stats=s.solver.accum_stats(),maxrss_kib=resource.getrusage(resource.RUSAGE_SELF).ru_maxrss,total_cpu=time.process_time()-began)
 rows.append(res);(HERE/(stem+'.json')).write_text(json.dumps(rows,indent=2)+'\n');print('RESULT',{k:v for k,v in res.items() if k!='used_cases'},flush=True)
 if res['status']=='CANDIDATE':s.emit(res,HERE/(stem+f'_b{base["id"]:02d}.s'))
 s.solver.delete();del s
