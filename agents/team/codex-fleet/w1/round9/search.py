"""One median-path test; limits never count as negatives."""
import argparse,json,os,resource,time
from pathlib import Path
from fast_synth import Synth
from normal import normalize_new_registers
HERE=Path(__file__).resolve().parent
def main():
 ap=argparse.ArgumentParser()
 ap.add_argument('--index',type=int,required=True)
 ap.add_argument('--mode',choices=['exclusive','tail','cone','schedule'],default='exclusive')
 ap.add_argument('--tail',type=int,default=6)
 ap.add_argument('--schedule-scope',choices=['exclusive','tail','cone'],default='tail')
 ap.add_argument('--cpu',type=float,default=30)
 ap.add_argument('--extra',type=int,default=2)
 ap.add_argument('--unbounded',action='store_true')
 ap.add_argument('--control',action='store_true')
 ap.add_argument('--all-cases',action='store_true')
 ap.add_argument('--stem',required=True)
 ap.add_argument('--resume-json')
 a=ap.parse_args();requested_cpu=a.cpu
 overrides=HERE/'budget_overrides.json'
 if overrides.exists():
  for rule in json.loads(overrides.read_text()):
   if a.stem.startswith(rule['prefix']) and a.index>=rule.get('min_index',0):a.cpu=min(a.cpu,rule['cpu'])
 os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
 if os.getpriority(os.PRIO_PROCESS,0)<19:os.nice(19-os.getpriority(os.PRIO_PROCESS,0))
 resource.setrlimit(resource.RLIMIT_AS,(2800*1024**2,2800*1024**2))
 resource.setrlimit(resource.RLIMIT_CPU,(int(a.cpu)+30,int(a.cpu)+35))
 base=json.loads((HERE/'bases.json').read_text())[a.index]
 if a.resume_json:
  previous=json.loads((HERE/a.resume_json).read_text())
  assert previous['key']==base['key']
  base=dict(base,seed_cases=previous.get('used_cases',[]))
 scope=a.schedule_scope if a.mode=='schedule' else a.mode
 editable=base['exclusive'] if scope=='exclusive' else base['median_cone'] if scope=='cone' else sorted(set(base['exclusive'])|set(base['writes'][-a.tail:]))
 # A 32-instruction base retains 32-m fixed instructions. At k=31,
 # at most m-1 free instructions are active, even with added positions.
 extra=2*max(0,len(editable)-(0 if a.control else 1)) if a.unbounded else a.extra
 started=time.process_time()
 if a.mode=='schedule':
  from scheduled import Scheduled
  s=Scheduled(base,editable,extra=extra,budget=32 if a.control else 31)
  if a.control:s.pin_original()
 else:
  s=Synth(base,editable,extra=extra,drop=0 if a.control else 1)
 if extra:normalize_new_registers(s,sorted(s.editable),len(base['names']),extra)
 res=s.run(a.cpu,control=a.control and a.mode!='schedule',all_cases=a.all_cases)
 res.update(args=vars(a),key=base['key'],editable=editable,used_cases=s.used,
  vars=s.pool.top,clauses=s.clauses,stats=s.solver.accum_stats(),
  maxrss_kib=resource.getrusage(resource.RUSAGE_SELF).ru_maxrss,total_cpu=time.process_time()-started,
  registers=s.r,extra_registers=extra,suffix_builds=getattr(s,'suffix_builds',None),schedule_normalized=getattr(s,'schedule_normalized',False),requested_cpu=requested_cpu)
 (HERE/(a.stem+'.json')).write_text(json.dumps(res,indent=2)+'\n')
 print('RESULT',{k:v for k,v in res.items() if k not in ('code','used_cases')},flush=True)
 if res['status']=='CANDIDATE':
  s.emit(res,HERE/(a.stem+'.s'))
 s.solver.delete()
if __name__=='__main__':main()
