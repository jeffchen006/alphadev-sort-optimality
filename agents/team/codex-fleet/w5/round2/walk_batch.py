"""Queue exact register aliases, then four correct-program walks on two CPUs."""
import concurrent.futures as cf
import json
from pathlib import Path
import subprocess
import sys
import threading
import time

HERE=Path(__file__).resolve().parent
manifest=json.loads((HERE/'manifest.json').read_text())
while not (HERE/'flag_results_cmp_cmov_other.json').exists():time.sleep(5)

def alias(row):
    name=f'{row["index"]:02d}_alias'
    with (HERE/'logs'/f'{name}.log').open('w') as f:
        p=subprocess.run(['nice','-n','19',str(HERE/'walk'),row['seed'],str(HERE/'candidates'/name),str(29000+row['index']),'0','0'],stdout=f,stderr=subprocess.STDOUT)
    print(json.dumps({'name':name,'code':p.returncode}),flush=True)
    return p.returncode
with cf.ThreadPoolExecutor(max_workers=2) as pool:
    alias_results=list(pool.map(alias,manifest))
if any(alias_results):raise RuntimeError(alias_results)

stop=threading.Event()
active={}
lock=threading.Lock()
def check_shorter(prefix):
    candidates=list((HERE/'candidates').glob(prefix+'*k31.s'))
    if not candidates:return False
    subprocess.run(['nice','-n','19',sys.executable,str(HERE/'verify.py'),*[str(p) for p in candidates]],check=True)
    target=HERE.parent/'RESULTS.md'
    lines=''.join('FOUND k=31 '+str(HERE/'verified'/p.name)+' (strict out and memory PASS)\n' for p in candidates)
    target.write_text(lines+'\n'+target.read_text())
    stop.set()
    with lock:
        for proc in active.values():
            if proc.poll() is None:proc.terminate()
    return True
for row in manifest:
    if check_shorter(f'{row["index"]:02d}_alias'):sys.exit(0)

# The first two seeds contain the two reused CMOV results from the audit.
# The third seed has two MOVs. The fourth is the palette route.
jobs=[(3,450,2602503),(15,450,2602515),(7,450,2602507),(18,450,2602518)]
def walk(job):
    index,seconds,seed=job
    if stop.is_set():return {'index':index,'stopped':True}
    name=f'walk_{index:02d}'
    start=time.monotonic()
    cmd=['nice','-n','19',str(HERE/'walk'),manifest[index]['seed'],str(HERE/'candidates'/name),str(seed),str(seconds),'2000']
    with (HERE/'logs'/f'{name}.log').open('w') as f:
        proc=subprocess.Popen(cmd,stdout=f,stderr=subprocess.STDOUT)
        with lock:active[index]=proc
        code=proc.wait()
        with lock:active.pop(index,None)
    result={'name':name,'code':code,'seconds':time.monotonic()-start}
    print(json.dumps(result),flush=True)
    check_shorter(name)
    return result
with cf.ThreadPoolExecutor(max_workers=2) as pool:
    results=list(pool.map(walk,jobs))
(HERE/'walk_results.json').write_text(json.dumps(results,indent=2)+'\n')
if not stop.is_set():
    sources=sorted((HERE/'candidates').glob('walk_*_final.s'))+sorted((HERE/'candidates').glob('walk_*_checkpoint.s'))
    subprocess.run(['nice','-n','19',sys.executable,str(HERE/'verify.py'),*[str(p) for p in sources]],check=True)
