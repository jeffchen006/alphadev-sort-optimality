"""Adaptive follow-up stages. Run only after the initial sequential batch ends."""
import json,os,resource,subprocess,sys
from pathlib import Path
HERE=Path(__file__).resolve().parent
def main():
 os.chdir(HERE.parent);os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
 if os.getpriority(os.PRIO_PROCESS,0)<19:os.nice(19-os.getpriority(os.PRIO_PROCESS,0))
 resource.setrlimit(resource.RLIMIT_AS,(2800*1024**2,2800*1024**2))
 jobs=[
  ('audit',[sys.executable,'round9/audit.py']),
  ('c9_tail6_retry',[sys.executable,'round9/retry.py','--source','c9_tail6','--cpu','90','--stem','c9_tail6_retry']),
  ('c9_cone',[sys.executable,'round9/batch.py','--kind','c9','--mode','cone','--unbounded','--cpu','8','--stem','c9_cone']),
  ('c8_schedule3_control',[sys.executable,'round9/batch.py','--kind','c8','--mode','schedule','--tail','3','--unbounded','--control','--end','9','--cpu','10','--stem','c8_schedule3_control']),
  ('c8_schedule3_pilot',[sys.executable,'round9/batch.py','--kind','c8','--mode','schedule','--tail','3','--unbounded','--end','8','--cpu','30','--stem','c8_schedule3_pilot']),
  ('c8_schedule_allcases',[sys.executable,'round9/batch.py','--kind','c8','--mode','schedule','--tail','6','--end','8','--all-cases','--cpu','45','--stem','c8_schedule_allcases']),
  ('c8_schedule3_retry',[sys.executable,'round9/retry.py','--source','c8_schedule3_rest','--cpu','120','--stem','c8_schedule3_retry']),
 ]
 for stem,cmd in jobs:
  print('START',stem,flush=True)
  with (HERE/(stem+'_phase.log')).open('w') as f:
   subprocess.run(['/usr/bin/time','-v','-o',str(HERE/(stem+'_phase.resources'))]+cmd,stdout=f,stderr=subprocess.STDOUT,check=True)
  print('DONE',stem,flush=True)
  if stem=='c8_schedule3_pilot':
   rows=json.loads((HERE/'c8_schedule3_pilot_batch.json').read_text())
   cpu=15 if sum(r['status']=='UNSAT' for r in rows)>=4 else 3
   rest=[sys.executable,'round9/batch.py','--kind','c8','--mode','schedule','--tail','3','--unbounded','--start','8','--cpu',str(cpu),'--stem','c8_schedule3_rest']
   print('START c8_schedule3_rest cpu',cpu,flush=True)
   with (HERE/'c8_schedule3_rest_phase.log').open('w') as f:
    subprocess.run(['/usr/bin/time','-v','-o',str(HERE/'c8_schedule3_rest_phase.resources')]+rest,stdout=f,stderr=subprocess.STDOUT,check=True)
   print('DONE c8_schedule3_rest',flush=True)
if __name__=='__main__':main()
