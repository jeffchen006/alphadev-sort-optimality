#!/usr/bin/env python3
"""Retry limited tail cases while the six-worker broad pass continues."""
import concurrent.futures
import json
from pathlib import Path
import re
import subprocess
import threading
import time

files=sorted(Path('sk/refresh_tail').glob('*.txt'))
logs=Path('logs/tail_deep')
logs.mkdir(parents=True,exist_ok=True)
summary=Path('logs/refresh_tail_batch.log')
lock=threading.Lock()
counts={}
started=time.monotonic()

def run(fn):
    dst=logs/(fn.stem+'.log')
    prog=Path('programs/deep_tail_'+fn.stem+'.s')
    if dst.exists() and re.search(r'^RESULT ',dst.read_text(),re.M):
        text=dst.read_text()
    else:
        with dst.open('w') as out:
            try:
                subprocess.run(['nice','-n','10','python3','src/pool_sat.py',str(fn),'31',
                                str(prog),'--conflicts','20000','--verify'],
                               stdout=out,stderr=subprocess.STDOUT,timeout=60,check=True)
            except subprocess.TimeoutExpired:
                out.write('RESULT TIMEOUT\n')
            except subprocess.CalledProcessError:
                out.write('RESULT ERROR\n')
        text=dst.read_text()
    result=re.findall(r'^RESULT (\w+)',text,re.M)[-1]
    with lock:
        counts[result]=counts.get(result,0)+1
        print(json.dumps(dict(done=sum(counts.values()),counts=counts,
                              seconds=round(time.monotonic()-started,1),last=fn.name)),flush=True)
    return result

seen=0
futures=[]
with concurrent.futures.ThreadPoolExecutor(max_workers=2) as pool:
    while True:
        lines=summary.read_text().splitlines() if summary.exists() else []
        states=[json.loads(line) for line in lines if line.startswith('{')]
        done=states[-1]['done'] if states else 0
        for fn in files[seen:done]:
            raw=Path('logs/refresh_tail')/(fn.stem+'.log')
            results=re.findall(r'^RESULT (\w+)',raw.read_text(),re.M)
            if results and results[-1] in ('LIMIT','TIMEOUT','ERROR'):
                futures.append(pool.submit(run,fn))
        seen=done
        if lines and lines[-1]=='BATCH COMPLETE':
            break
        time.sleep(5)
    for future in concurrent.futures.as_completed(futures):
        future.result()
print(json.dumps(dict(total=len(futures),counts=counts,
                      seconds=round(time.monotonic()-started,1))),flush=True)
print('BATCH COMPLETE',flush=True)
