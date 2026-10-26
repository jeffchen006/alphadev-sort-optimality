import argparse,json,os,resource,time
from pathlib import Path
from synth import Synth
HERE=Path(__file__).resolve().parent
ap=argparse.ArgumentParser();ap.add_argument('--mode',choices=['exclusive','tail','all'],required=True);ap.add_argument('--tail',type=int,default=6);ap.add_argument('--cpu',type=float,default=60);ap.add_argument('--extra',type=int,default=2);ap.add_argument('--start',type=int,default=0);ap.add_argument('--end',type=int,default=16);ap.add_argument('--all-cases',action='store_true');args=ap.parse_args()
os.sched_setaffinity(0,{min(os.sched_getaffinity(0))});resource.setrlimit(resource.RLIMIT_AS,(2800*1024**2,2800*1024**2))
rows=[];stem=args.mode+(str(args.tail) if args.mode=='tail' else '')+f'_r{args.extra}'
if args.all_cases:stem+='_allcases'
if args.start!=0 or args.end!=16:stem+=f'_b{args.start}_{args.end}'
for base in json.loads((HERE/'bases.json').read_text())[args.start:args.end]:
 editable=base['exclusive'] if args.mode=='exclusive' else sorted(set(base['exclusive'])|set(base['writes'][-args.tail:])) if args.mode=='tail' else base['median_cone']
 started=time.process_time();s=Synth(base,editable,args.extra);res=s.run(args.cpu,all_cases=args.all_cases);res.update(used_cases=s.used,base=base['id'],editable=editable,args=vars(args),vars=s.pool.top,clauses=s.clauses,stats=s.solver.accum_stats(),maxrss_kib=resource.getrusage(resource.RUSAGE_SELF).ru_maxrss,total_cpu=time.process_time()-started)
 rows.append(res);(HERE/(stem+'.json')).write_text(json.dumps(rows,indent=2)+'\n');print('RESULT',{k:v for k,v in res.items() if k!='used_cases'},flush=True)
 if res['status']=='CANDIDATE':s.emit(res,HERE/(stem+f'_b{base["id"]:02d}.s'))
 s.solver.delete();del s
