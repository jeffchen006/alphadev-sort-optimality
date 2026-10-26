"""Run remaining validation steps in sequence on one CPU."""
import os,resource,subprocess,sys
from pathlib import Path
HERE=Path(__file__).resolve().parent;os.chdir(HERE.parent)
os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
if os.getpriority(os.PRIO_PROCESS,0)<19:os.nice(19-os.getpriority(os.PRIO_PROCESS,0))
resource.setrlimit(resource.RLIMIT_AS,(2800*1024**2,2800*1024**2))
def run(cmd,stem):
 print('RUN',stem,flush=True)
 with (HERE/(stem+'.log')).open('w') as f:subprocess.run(['/usr/bin/time','-v','-o',str(HERE/(stem+'.resources'))]+cmd,stdout=f,stderr=subprocess.STDOUT,check=True)
 print('DONE',stem,flush=True)
run([sys.executable,'round7/structure.py'],'structure')
run([sys.executable,'round7/audit.py'],'audit')
run([sys.executable,'round7/schedule.py','--control','--cpu','30'],'schedule_control')
run([sys.executable,'round7/check_schedule.py'],'check_schedule')
run(['g++','-O3','-std=c++17','round7/check_two.cpp','-o','round7/check_two'],'build_two')
run(['round7/check_two','round7/check_two.txt'],'check_two')
run([sys.executable,'round7/verify.py'],'verify')
print('ALL_VALIDATION_DONE',flush=True)
