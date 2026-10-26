"""Full round-8 driver. Earlier rounds are read as input, never rerun."""
import os,resource,subprocess,sys
from pathlib import Path
HERE=Path(__file__).resolve().parent;WORK=HERE.parent;os.chdir(WORK)
os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
if os.getpriority(os.PRIO_PROCESS,0)<19:os.nice(19-os.getpriority(os.PRIO_PROCESS,0))
resource.setrlimit(resource.RLIMIT_AS,(2800*1024**2,2800*1024**2))
def run(stem,cmd):
 print('RUN',stem,flush=True)
 with (HERE/(stem+'.log')).open('w') as f:
  subprocess.run(['/usr/bin/time','-v','-o',str(HERE/(stem+'.resources'))]+cmd,stdout=f,stderr=subprocess.STDOUT,check=True)
run('prepare',[sys.executable,'round8/prepare.py'])
run('control_batch',[sys.executable,'round8/batch.py','--mode','exclusive','--control','--end','32','--cpu','15','--stem','control'])
run('verify',[sys.executable,'round8/verify.py','control_[0-9][0-9].s'])
run('exclusive_batch',[sys.executable,'round8/batch.py','--mode','exclusive','--cpu','30','--stem','exclusive'])
run('exclusive_retry_batch',[sys.executable,'round8/retry.py','--cpu','120','--all-cases'])
run('next',[sys.executable,'round8/next.py'])
run('finish',[sys.executable,'round8/finish.py','--append'])
print('DONE',flush=True)
