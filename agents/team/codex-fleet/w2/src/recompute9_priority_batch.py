#!/usr/bin/env python3
"""Sequential routing retries with explicit limits and partial-bound priority."""
import argparse
import collections
import hashlib
import json
from pathlib import Path
import re
import resource
import subprocess
import time

p=argparse.ArgumentParser()
p.add_argument('--pilot-only',action='store_true')
p.add_argument('--engine',default='./dagx_priority')
p.add_argument('--folder',default='logs/recompute9_priority')
p.add_argument('--reuse-priority')
p.add_argument('--future',action='store_true')
p.add_argument('--nodes',type=int,default=60000000)
p.add_argument('--seconds',type=int,default=1800)
a=p.parse_args()
resource.setrlimit(resource.RLIMIT_AS,(2800000000,2800000000))
base=Path(a.folder);base.mkdir(exist_ok=True)
sk=Path('sk/recompute9_wide')
engine=a.engine
if a.future:
    import os
    os.environ['FUTURE']='1'
metadata=dict(engine=engine,engine_sha256=hashlib.sha256(Path(engine).read_bytes()).hexdigest(),nodes=a.nodes,seconds=a.seconds,future=a.future,nice=19,address_space=2800000000)
(base/'run.json').write_text(json.dumps(metadata,indent=2)+'\n')

def run(fn,folder,nodes,seconds):
    folder.mkdir(exist_ok=True)
    dst=folder/(fn.stem+'.log')
    if dst.exists() and re.search(r'^RESULT ',dst.read_text(),re.M):
        return dst.read_text()
    with dst.open('w') as f:
        f.write(f'RUN skeleton={fn} node_limit={nodes} seconds={seconds} nice=19 address_space=2800000000 engine={engine} future={a.future}\n');f.flush()
        start=time.monotonic()
        try:
            subprocess.run(['nice','-n','19',engine,str(fn),'31','1',str(nodes)],
                           stdout=f,stderr=subprocess.STDOUT,timeout=seconds,check=True)
        except subprocess.TimeoutExpired:
            f.write(f'RESULT TIMEOUT seconds={seconds} (unknown; not exhaustive)\n')
        except subprocess.CalledProcessError as e:
            f.write(f'RESULT ERROR returncode={e.returncode} (unknown)\n')
        f.write(f'RUN_END elapsed={time.monotonic()-start:.3f}\n')
    txt=dst.read_text()
    if re.search(r'^RESULT FOUND',txt,re.M):
        check=subprocess.run(['nice','-n','19','python3','src/verify_log.py',str(dst),'recompute9_priority_'+fn.stem],
                             capture_output=True,text=True)
        with dst.open('a') as f:f.write(check.stdout+check.stderr)
        print(check.stdout+check.stderr,flush=True)
    return dst.read_text()

def status(txt):
    matches=re.findall(r'^RESULT (\w+).*$',txt,re.M)
    return matches[-1] if matches else 'INCOMPLETE'

files=sorted(sk.glob('r*.txt'))
records=[]
if a.reuse_priority:
    records=json.loads(Path(a.reuse_priority).read_text())
else:
    for i,fn in enumerate(files,1):
        txt=run(fn,base/'pilot',200000,120)
        rows=[tuple(map(int,m)) for m in re.findall(r'^PARTIAL prefix=(\d+) min_bound=(\d+) gates=(\d+) copies=(\d+) visits=(\d+)',txt,re.M)]
        deepest=max(rows,default=(0,999,0,0,0))
        root=re.search(r'lb\(root\)=(\d+)',txt)
        records.append(dict(file=fn.name,prefix=deepest[0],partial_bound=deepest[1],gates=deepest[2],copies=deepest[3],root=int(root.group(1)) if root else 999,pilot_status=status(txt)))
        print(json.dumps(dict(phase='pilot',done=i,total=len(files),**records[-1])),flush=True)
# Every pilot reaches nine resolved comparisons in normal runs. Keep this
# prefix fixed for comparing bounds; lower bounds have first priority.
records.sort(key=lambda r:(r['partial_bound'] if r['prefix']==9 else 999,-r['prefix'],r['root'],r['file']))
(base/'priority.json').write_text(json.dumps(records,indent=2)+'\n')
if a.pilot_only:raise SystemExit
counts=collections.Counter();calls=0;start=time.monotonic()
for i,r in enumerate(records,1):
    txt=run(sk/r['file'],base/'deep',a.nodes,a.seconds)
    st=status(txt);counts[st]+=1
    matches=re.findall(r'^RESULT .*calls=(\d+)',txt,re.M)
    if matches:calls+=int(matches[-1])
    summary=dict(done=i,total=len(records),counts=dict(counts),calls=calls,node_limit=a.nodes,seconds=a.seconds,
                 elapsed=round(time.monotonic()-start,1),last=r['file'],child_peak_rss_kib=resource.getrusage(resource.RUSAGE_CHILDREN).ru_maxrss)
    (base/'summary.json').write_text(json.dumps(summary,indent=2)+'\n')
    print(json.dumps(dict(phase='deep',priority=r,**summary)),flush=True)
    if st=='FOUND':
        print('STOP: candidate needs strict judge audit',flush=True)
        break
print('BATCH COMPLETE',flush=True)
