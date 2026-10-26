#!/usr/bin/env python3
"""Route selected skeletons with the finite-pool SAT model and verify SATs."""
import argparse
import concurrent.futures
import fcntl
import json
from pathlib import Path
import re
import subprocess
import time

p=argparse.ArgumentParser()
p.add_argument('--jobs',type=int,default=6)
p.add_argument('--conflicts',type=int,default=20000)
p.add_argument('--seconds',type=int,default=25)
a=p.parse_args()
lock=Path('.sat_batch.lock').open('w')
fcntl.flock(lock,fcntl.LOCK_EX)
selected=Path('sk/sat_selected')
selected.mkdir(parents=True,exist_ok=True)
groups={}
early_log=Path('logs/sat_selected_early_batch.log')
early_complete=(early_log.exists() and early_log.read_text().rstrip().endswith('BATCH COMPLETE')
                and len(list(selected.glob('*.txt')))>=694)
source_files=list(Path('sk/refresh_tail').glob('*.txt'))
if not early_complete:
    source_files += list(Path('sk/refresh').glob('*.txt'))+list(Path('sk/nonlattice10').glob('*.txt'))
for fn in source_files:
    key=fn.stem.split('_g')[0]
    text=fn.read_text()
    counts=re.search(r'alternatives=([\d,]+)',text.splitlines()[0]).group(1)
    alts=1
    for count in counts.split(','):
        alts*=int(count)
    if '_q' in fn.stem:
        key=fn.stem.rsplit('_',1)[0]
    if '_tail_' in fn.stem:
        key=fn.stem.split('_tail_')[0]+'_tail'
    # Count required full columns. This is a gate lower bound only.
    terms=set()
    for line in text.splitlines():
        if line.startswith('#'):
            continue
        parts=line.split(';')[0].split(':')
        terms.update(parts)
    groups.setdefault(key,[]).append((alts,len(terms),fn))
for key,records in groups.items():
    choices={max(records,key=lambda x:(x[0],-x[1]))[2],
             min(records,key=lambda x:(x[1],-x[0]))[2]}
    for fn in choices:
        (selected/fn.name).write_text(fn.read_text())
for fn in Path('sk/nonlattice10').glob('w6_*.txt'):
    (selected/fn.name).write_text(fn.read_text())
files=sorted(selected.glob('*.txt'))
logs=Path('logs/sat_selected')
logs.mkdir(parents=True,exist_ok=True)

def run(fn):
    dest=logs/(fn.stem+'.log')
    prog=Path('programs/sat_'+fn.stem+'.s')
    if dest.exists() and 'FINAL' in dest.read_text():
        return dest.read_text().splitlines()[-1]
    shared=Path('logs/nonlattice10')/(fn.stem+'.log')
    if fn.stem.startswith('w6_') and shared.exists():
        previous=shared.read_text()
        results=re.findall(r'^RESULT (\w+)',previous,re.M)
        if 'ENCODED pool=' in previous and results and results[-1] in ('UNSAT','LIMIT','FOUND','REJECTED'):
            status=results[-1]
            dest.write_text('REUSED '+str(shared)+'\n'+previous+'FINAL '+status+'\n')
            return 'FINAL '+status
    with dest.open('w') as out:
        try:
            cmd=['nice','-n','10','python3','src/pool_sat.py',str(fn),'31',
                 str(prog),'--conflicts',str(a.conflicts)]
            if '_q' in fn.stem:
                hint=('/path/to/repo/agents/team/codex-fleet/w6/candidates/c8c_len32_c29288.s'
                      if fn.stem.startswith('w6_') else
                      '/path/to/repo/agents/team/d4-evolve/codex/work/position33_valid.txt')
                cmd+=['--hint',hint]
            subprocess.run(cmd,
                           stdout=out,stderr=subprocess.STDOUT,timeout=a.seconds,check=True)
        except subprocess.TimeoutExpired:
            out.write('FINAL TIMEOUT\n')
            return 'FINAL TIMEOUT'
        except subprocess.CalledProcessError:
            out.write('FINAL ERROR\n')
            return 'FINAL ERROR'
    text=dest.read_text()
    status=re.search(r'RESULT (\w+)',text).group(1)
    if status=='SAT':
        check=subprocess.run(['nice','-n','10','python3','src/verify_log.py',str(prog),
                              prog.stem],capture_output=True,text=True)
        with dest.open('a') as out:
            out.write(check.stdout+check.stderr)
        status='FOUND' if check.stdout.count('PASS ')==2 else 'REJECTED'
        if status=='REJECTED':
            repaired=prog.with_name(prog.stem+'_repaired.s')
            try:
                fix=subprocess.run(['nice','-n','10','python3','src/repair_ties.py',
                                    str(prog),str(repaired)],capture_output=True,text=True,timeout=30)
                with dest.open('a') as out:
                    out.write(fix.stdout+fix.stderr)
                if repaired.exists():
                    check=subprocess.run(['nice','-n','10','python3','src/verify_log.py',
                                          str(repaired),repaired.stem],capture_output=True,text=True)
                    with dest.open('a') as out:
                        out.write(check.stdout+check.stderr)
                    if check.stdout.count('PASS ')==2:
                        status='FOUND'
            except subprocess.TimeoutExpired:
                with dest.open('a') as out:
                    out.write('TIE_REPAIR TIMEOUT\n')
    with dest.open('a') as out:
        out.write('FINAL '+status+'\n')
    return 'FINAL '+status

counts={}
t0=time.monotonic()
with concurrent.futures.ThreadPoolExecutor(max_workers=a.jobs) as pool:
    for i,result in enumerate(pool.map(run,files),1):
        status=result.split()[1]
        counts[status]=counts.get(status,0)+1
        if i%10==0 or status in ('FOUND','ERROR') or i==len(files):
            print(json.dumps(dict(done=i,total=len(files),counts=counts,
                                  seconds=round(time.monotonic()-t0,1))),flush=True)
print('BATCH COMPLETE',flush=True)
