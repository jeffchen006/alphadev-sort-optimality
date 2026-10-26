"""Reproduce round 4 with sequential CPU jobs and a 2,800 MiB limit.

The broad free-comparison pilot was interrupted. Reproduction uses its recorded
completed prefix. That prefix does not exhaust the full family.
"""
import json
import os
from pathlib import Path
import re
import resource
import subprocess
import time

HERE=Path(__file__).resolve().parent
WORK=HERE.parent
ROOT=HERE.parents[4]
JUDGE=ROOT/'shared/judge.py'
os.chdir(WORK)
os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
os.nice(19)
resource.setrlimit(resource.RLIMIT_AS,(2800*1024**2,2800*1024**2))
ledger=[]

def run(args,stem,measured=False):
    log=HERE/f'{stem}.log'
    started=time.monotonic()
    command=list(map(str,args))
    with log.open('w') as out,(HERE/f'{stem}.resources').open('w') as err:
        result=subprocess.run((['/usr/bin/time','-v'] if measured else [])+command,
                              stdout=out,stderr=err)
    ledger.append({'args':command,'exit':result.returncode,'log':str(log.relative_to(WORK)),
                   'wall_seconds':time.monotonic()-started})
    (HERE/'reproduction.json').write_text(json.dumps(ledger,indent=2)+'\n')
    print(stem,'exit',result.returncode,'seconds',round(ledger[-1]['wall_seconds'],3),flush=True)
    assert result.returncode==0,(log,(HERE/f'{stem}.resources').read_text()[-3000:])
    return log

def found(log):
    for line in log.read_text().splitlines():
        match=re.match(r'CANDIDATE file=(\S+) k=(\d+)',line)
        if not match: continue
        path=Path(match[1]);k=int(match[2])
        judge=run(['python3',JUDGE,path,'--strict','--model','out'],path.stem+'_judge')
        assert judge.read_text().startswith('PASS '),judge.read_text()
        if k>31: continue
        mem=HERE/'found_mem.s'
        run(['python3','round3/lower.py',path,mem],'found_lower')
        judge=run(['python3',JUDGE,mem,'--strict','--model','mem'],'found_mem_judge')
        assert judge.read_text().startswith('PASS ')
        report=WORK/'RESULTS.md'
        report.write_text(f'FOUND k={k} total={k+10} strict out+mem PASS: {path}, {mem}\n\n'
                          +report.read_text())
        raise SystemExit(0)

# Save the completed prefix before a reproduction can overwrite its log.
pilot=HERE/'reuse_pilot.log'
prefix_count=sum(line.startswith('RESULT ') for line in pilot.read_text().splitlines()) if pilot.exists() else 0
run(['python3','round4/prepare.py'],'prepare')
run(['g++','-O3','-std=c++17','-march=native','round4/edit.cpp','-o','round4/edit'],'edit_build')
run(['./round4/edit','--dump-cases'],'cases')
(HERE/'cases.txt').write_text((HERE/'cases.log').read_text())
run(['python3','round4/controls.py'],'controls')
for mode,label in [(0,'fixed'),(1,'free')]:
    log=run(['./round4/edit','round4/control.txt',0,1,mode,31,32,f'round4/control_{label}'],f'control_{label}')
    found(log)
    log=run(['./round4/edit','round4/bases.txt',0,170,mode,0,496,f'round4/{label}'],label,True)
    found(log)
run(['python3','round4/crosscheck.py'],'crosscheck',True)
run(['python3','round3/lower.py','round4/control_free_padded33_0_32_0_0_5_2.s',
     'round4/control_mem42.s'],'control_lower')
run(['python3',JUDGE,'round4/control_mem42.s','--strict','--model','mem'],'control_mem_judge')
run(['python3','round4/prepare_router.py'],'prepare_router')
run(['g++','-O3','-std=c++17','-march=native','round4/reuse.cpp','-o','round4/reuse'],'reuse_build')
log=run(['./round4/reuse','round4/control_problem.txt',0,1,23,24,10,
         'round4/reuse_control',32,0],'reuse_control')
found(log)
test=json.loads((HERE/'control_copy_test.json').read_text())['test']
log=run(['./round4/reuse','round4/control_problem.txt',0,1,test,test+1,30,
         'round4/reuse_copy_control',32,1,1,1],'reuse_copy_control')
found(log)
if prefix_count:
    log=run(['./round4/reuse','round4/problems.txt',144,145,0,prefix_count,2,
             'round4/reuse_pilot',31,1],'reuse_pilot',True)
    found(log)

# Other completed global-reuse ranges are listed explicitly in runs.json.
runs=HERE/'runs.json'
if runs.exists():
    for row in json.loads(runs.read_text()):
        log=run(row['args'],row['stem'],True)
        found(log)
run(['python3','round4/resolve.py'],'resolve',True)
for row in json.loads((HERE/'resolve_runs.json').read_text()):
    found(HERE/f"{row['stem']}.log")
run(['python3','round4/summarize.py'],'summary')
print('COMPLETE round 4 reproduction',flush=True)
