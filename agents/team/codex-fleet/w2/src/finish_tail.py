#!/usr/bin/env python3
"""Use six free workers on deep cases after the broad batches finish."""
import concurrent.futures
import json
from pathlib import Path
import re
import subprocess
import time

logs=Path('logs/tail_deep_accel')
logs.mkdir(parents=True,exist_ok=True)
control=Path('logs/c10_competitive32.log')
if not control.exists():
    with control.open('w') as out:
        try:
            subprocess.run(['nice','-n','10','python3','src/pool_sat.py',
                            'sk/control_flags.txt','32','programs/c10_competitive32.s',
                            '--conflicts','50000','--hint','programs/control_flags_k33.s'],
                           stdout=out,stderr=subprocess.STDOUT,timeout=40,check=True)
        except subprocess.TimeoutExpired:
            out.write('RESULT TIMEOUT\n')
        except subprocess.CalledProcessError:
            out.write('RESULT ERROR\n')
    if re.search(r'^RESULT SAT\b',control.read_text(),re.M):
        check=subprocess.run(['nice','-n','10','python3','src/verify_log.py',
                              'programs/c10_competitive32.s','c10_competitive32'],
                             capture_output=True,text=True)
        with control.open('a') as out:
            out.write(check.stdout+check.stderr)
        if check.stdout.count('PASS ')!=2:
            fix=subprocess.run(['nice','-n','10','python3','src/repair_ties.py',
                                'programs/c10_competitive32.s',
                                'programs/c10_competitive32_repaired.s'],capture_output=True,text=True)
            with control.open('a') as out:
                out.write(fix.stdout+fix.stderr)
            if Path('programs/c10_competitive32_repaired.s').exists():
                check=subprocess.run(['nice','-n','10','python3','src/verify_log.py',
                                      'programs/c10_competitive32_repaired.s',
                                      'c10_competitive32_repaired'],capture_output=True,text=True)
                with control.open('a') as out:
                    out.write(check.stdout+check.stderr)
def eligible(fn):
    raw=Path('logs/refresh_tail')/(fn.stem+'.log')
    status=re.findall(r'^RESULT (\w+)',raw.read_text(),re.M)
    if status and status[-1] in ('LIMIT','TIMEOUT','ERROR'):
        if not (Path('logs/tail_deep')/(fn.stem+'.log')).exists():
            return fn
    return None

with concurrent.futures.ThreadPoolExecutor(max_workers=6) as readers:
    files=[fn for fn in readers.map(eligible,reversed(sorted(Path('sk/refresh_tail').glob('*.txt'))))
           if fn is not None]

def run(fn):
    dst=logs/(fn.stem+'.log')
    # The two-worker pass processes cases in the opposite order.
    prior=Path('logs/tail_deep')/(fn.stem+'.log')
    if prior.exists():
        return 'BUSY_OR_DONE'
    prog=Path('programs/accel_tail_'+fn.stem+'.s')
    with dst.open('w') as out:
        try:
            subprocess.run(['nice','-n','10','python3','src/pool_sat.py',str(fn),'31',
                            str(prog),'--conflicts','20000','--verify'],stdout=out,
                           stderr=subprocess.STDOUT,timeout=60,check=True)
        except subprocess.TimeoutExpired:
            out.write('RESULT TIMEOUT\n')
        except subprocess.CalledProcessError:
            out.write('RESULT ERROR\n')
    return re.findall(r'^RESULT (\w+)',dst.read_text(),re.M)[-1]

counts={}
t0=time.monotonic()
with concurrent.futures.ThreadPoolExecutor(max_workers=6) as pool:
    for i,status in enumerate(pool.map(run,files),1):
        counts[status]=counts.get(status,0)+1
        if i%10==0 or status in ('FOUND','ERROR') or i==len(files):
            print(json.dumps(dict(done=i,total=len(files),counts=counts,
                                  seconds=round(time.monotonic()-t0,1))),flush=True)
print('BATCH COMPLETE',flush=True)
