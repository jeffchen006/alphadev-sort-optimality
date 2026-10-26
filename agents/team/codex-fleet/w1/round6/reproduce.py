"""Run only this round. Invoke with nice -n 19. One CPU job at a time."""
import os
import resource
import subprocess
import sys
from pathlib import Path

HERE=Path(__file__).resolve().parent
os.chdir(HERE.parent)
os.sched_setaffinity(0,{68})
if os.getpriority(os.PRIO_PROCESS,0)<19:os.nice(19-os.getpriority(os.PRIO_PROCESS,0))
resource.setrlimit(resource.RLIMIT_AS,(2800*1024**2,2800*1024**2))

def run(command,log):
    print('RUN',command,flush=True)
    with (HERE/log).open('w') as f:
        subprocess.run(command,stdout=f,stderr=subprocess.STDOUT,check=True)

run([sys.executable,'round6/prepare.py'],'prepare.log')
for name in ['insert','check']:
    run(['g++','-O3','-std=c++17',f'round6/{name}.cpp','-o',f'round6/{name}'],f'build_{name}.log')
for mode,free,delete in [('fixed',0,0),('free',1,0),('relocate_fixed',0,1),('relocate_free',1,1)]:
    run(['/usr/bin/time','-v','-o',f'round6/{mode}.resources','round6/insert','round6/bases.txt',str(free),str(delete),f'round6/{mode}'],f'{mode}.log')
    run(['/usr/bin/time','-v','-o',f'round6/check_{mode}.resources','round6/check','round6/bases.txt',str(free),str(delete),f'round6/check_{mode}.jsonl'],f'check_{mode}.log')
run(['/usr/bin/time','-v','-o','round6/verify.resources',sys.executable,'round6/verify.py'],'verify.log')
run([sys.executable,'round6/audit.py'],'audit.log')
print('DONE',flush=True)
