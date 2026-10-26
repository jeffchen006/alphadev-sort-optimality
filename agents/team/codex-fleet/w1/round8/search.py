"""One finite two-output SAT rewrite. Run with nice -n 19."""
import argparse,json,os,resource,time
from pathlib import Path
from synth import Synth
HERE=Path(__file__).resolve().parent
def normalize_new_registers(s,editable,old,extra):
 # Name fresh registers in order of first occurrence, destination before source.
 prior=[]
 for t in sorted(editable):
  _,d,src=s.choice[t]
  for e in range(1,extra):
   seen=[v for pt in prior for v in (s.choice[pt][1][old+e-1],s.choice[pt][2][old+e-1])]
   s.add(-d[old+e],*seen)
   s.add(-src[old+e],d[old+e-1],*seen)
  prior.append(t)
def family(base,mode,tail):
 if mode=='exclusive':return base,base['exclusive'],[]
 if mode=='tail':return base,sorted(set(base['exclusive'])|set(base['pair_writes'][-tail:])),[]
 if mode=='cone':return base,base['pair_cone'],[]
 raise ValueError(mode)
def main():
 ap=argparse.ArgumentParser()
 ap.add_argument('--index',type=int,required=True)
 ap.add_argument('--mode',choices=['exclusive','tail','cone'],default='exclusive')
 ap.add_argument('--tail',type=int,default=6);ap.add_argument('--cpu',type=float,default=60)
 ap.add_argument('--extra',type=int,default=2);ap.add_argument('--control',action='store_true')
 ap.add_argument('--all-cases',action='store_true');ap.add_argument('--stem',required=True)
 ap.add_argument('--fast',action='store_true')
 ap.add_argument('--unbounded',action='store_true')
 a=ap.parse_args();os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
 if os.getpriority(os.PRIO_PROCESS,0)<19:os.nice(19-os.getpriority(os.PRIO_PROCESS,0))
 resource.setrlimit(resource.RLIMIT_AS,(2800*1024**2,2800*1024**2))
 resource.setrlimit(resource.RLIMIT_CPU,(int(a.cpu)+30,int(a.cpu)+35))
 original=json.loads((HERE/'bases.json').read_text())[a.index]
 base,editable,groups=family(original,a.mode,a.tail)
 drop=0 if a.control or original['kind']=='near' else 1
 start=time.process_time()
 engine=Synth
 if a.fast:
  from fast_synth import Synth as FastSynth
  engine=FastSynth
 extra=2*len(editable) if a.unbounded else a.extra
 s=engine(base,editable,extra,drop=drop,free_outputs=original['free_outputs'])
 if a.unbounded:
  normalize_new_registers(s,editable,len(base['names']),extra)
 res=s.run(a.cpu,control=a.control,all_cases=a.all_cases)
 res.update(args=vars(a),key=base['key'],editable=editable,drop=drop,
  free_outputs=base['free_outputs'],used_cases=s.used,vars=s.pool.top,clauses=s.clauses,
  stats=s.solver.accum_stats(),maxrss_kib=resource.getrusage(resource.RUSAGE_SELF).ru_maxrss,
  total_cpu=time.process_time()-start,suffix_builds=getattr(s,'suffix_builds',None),registers=s.r)
 (HERE/(a.stem+'.json')).write_text(json.dumps(res,indent=2)+'\n')
 print('RESULT',{k:v for k,v in res.items() if k not in ('used_cases','code')},flush=True)
 if res['status']=='CANDIDATE':s.emit(res,HERE/(a.stem+'.s'))
 s.solver.delete()
if __name__=='__main__':main()
