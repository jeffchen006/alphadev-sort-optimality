"""Run the two frozen new-class queues with one routing child at a time."""
import subprocess,os,resource
from pathlib import Path
os.nice(19-os.nice(0))
resource.setrlimit(resource.RLIMIT_AS,(3*1024**3,3*1024**3))
for family in ('rotation','repeat10'):
    dst=Path('logs')/f'round4_{family}.batch.log'
    with dst.open('a') as stream:
        r=subprocess.run(['python3','src/round4_run.py','--manifest',f'sk/round4_{family}.json','--tag',f'round4_{family}','--mode','13'],stdout=stream,stderr=subprocess.STDOUT)
    print(family,r.returncode,flush=True)
    if r.returncode:break
