#!/usr/bin/env python3
"""One CPU job at a time, nice 19, finite node and address-space limits."""
import argparse
import json
from pathlib import Path
import re
import resource
import subprocess
import time

p=argparse.ArgumentParser()
p.add_argument('skeletons')
p.add_argument('logs')
p.add_argument('--nodes',type=int,default=3000000)
p.add_argument('--seconds',type=int,default=180)
p.add_argument('--cost',type=int,default=31)
p.add_argument('--engine',default='./dagx_safe')
p.add_argument('--retry',action='store_true')
a=p.parse_args()
resource.setrlimit(resource.RLIMIT_AS,(2900000000,2900000000))
out=Path(a.logs);out.mkdir(parents=True,exist_ok=True)
files=sorted(Path(a.skeletons).glob('r*.txt'))
counts={};calls=0
start=time.monotonic()
for i,fn in enumerate(files,1):
    dst=out/(fn.stem+'.log')
    existing=dst.read_text() if dst.exists() else ''
    if 'RESULT' in existing and (not a.retry or re.search(r'RESULT (NONE|FOUND)',existing)):
        text=existing
    else:
        with dst.open('w') as f:
            try:
                subprocess.run(['nice','-n','19',a.engine,str(fn),str(a.cost),'1',str(a.nodes)],
                               stdout=f,stderr=subprocess.STDOUT,timeout=a.seconds,check=True)
            except subprocess.TimeoutExpired:
                f.write(f'RESULT TIMEOUT seconds={a.seconds} (unknown; not exhaustive)\n')
            except subprocess.CalledProcessError as e:
                f.write(f'RESULT ERROR returncode={e.returncode} (unknown)\n')
        text=dst.read_text()
    result=[l for l in text.splitlines() if l.startswith('RESULT')][-1]
    status=result.split()[1]
    m=re.search(r'calls=(\d+)',result)
    if m:calls+=int(m.group(1))
    if status=='FOUND':
        check=subprocess.run(['nice','-n','19','python3','src/verify_log.py',str(dst),'recompute9_route_'+fn.stem],
                             capture_output=True,text=True,check=True)
        with dst.open('a') as f:
            f.write(check.stdout+check.stderr)
        status='PASS' if check.stdout.count('PASS ')==2 else 'REJECTED'
        with dst.open('a') as f:
            f.write('VERIFIED_RESULT '+status+'\n')
        print(check.stdout+check.stderr,end='',flush=True)
    counts[status]=counts.get(status,0)+1
    print(json.dumps(dict(done=i,total=len(files),counts=counts,calls=calls,
                         elapsed=round(time.monotonic()-start,1),file=fn.name,result=result)),flush=True)
summary=dict(total=len(files),counts=counts,calls=calls,nodes=a.nodes,seconds=a.seconds,cost=a.cost,
             child_peak_rss_kib=resource.getrusage(resource.RUSAGE_CHILDREN).ru_maxrss)
(out/'summary.json').write_text(json.dumps(summary,indent=2)+'\n')
print('BATCH COMPLETE',flush=True)
