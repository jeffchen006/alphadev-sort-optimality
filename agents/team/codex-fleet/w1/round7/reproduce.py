"""Run this round with one CPU job at a time. No earlier round is rerun."""
import os,resource,subprocess,sys
from pathlib import Path
HERE=Path(__file__).resolve().parent;os.chdir(HERE.parent)
os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
if os.getpriority(os.PRIO_PROCESS,0)<19:os.nice(19-os.getpriority(os.PRIO_PROCESS,0))
resource.setrlimit(resource.RLIMIT_AS,(2800*1024**2,2800*1024**2))
def run(cmd,stem):
 print('RUN',cmd,flush=True)
 with (HERE/(stem+'.log')).open('w') as f:subprocess.run(['/usr/bin/time','-v','-o',str(HERE/(stem+'.resources'))]+cmd,stdout=f,stderr=subprocess.STDOUT,check=True)
run([sys.executable,'round7/analyze.py'],'analyze')
run([sys.executable,'round7/structure.py'],'structure')
run([sys.executable,'round7/audit.py'],'audit')
run([sys.executable,'round7/synth.py','--base','10','--control','--stem','control'],'control')
for mode,tail,cpu in [('exclusive',6,30),('tail',6,45),('tail',8,60)]:
 run([sys.executable,'round7/batch.py','--mode',mode,'--tail',str(tail),'--cpu',str(cpu)],mode+str(tail))
run([sys.executable,'round7/schedule.py','--cpu','45'],'schedule')
run([sys.executable,'round7/schedule.py','--start','10','--end','11','--cpu','300'],'schedule_retry')
run([sys.executable,'round7/probe.py'],'probe')
run([sys.executable,'round7/finish.py'],'finish')
print('DONE',flush=True)
