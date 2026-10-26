#!/usr/bin/env python3
"""Run bounded routing jobs, with explicit limit reporting."""
import argparse, concurrent.futures, json, subprocess, time, re, resource
from pathlib import Path
p=argparse.ArgumentParser();p.add_argument('manifest');p.add_argument('--nodes',type=int,default=300000)
p.add_argument('--seconds',type=int,default=45);p.add_argument('--jobs',type=int,default=6)
p.add_argument('--tag',default='partner');p.add_argument('--cost',type=int,default=31)
p.add_argument('--reuse',nargs='*',default=[])
a=p.parse_args();assert 1<=a.jobs<=8
out=Path('logs')/a.tag;out.mkdir(exist_ok=True)
manifest=json.loads(Path(a.manifest).read_text())
reused={}
for file in a.reuse:
    for line in Path(file).read_text().splitlines():
        row=json.loads(line)
        if row['status'] in ('NONE','LIMIT','TIMEOUT','FOUND'):
            reused[row['file']]=row
if reused:
    manifest=[row for row in manifest if row['file'] not in reused]
    print(json.dumps(dict(reused=len(reused),remaining=len(manifest))),flush=True)
def limits():resource.setrlimit(resource.RLIMIT_AS,(3*1024**3,3*1024**3))
def run(row):
    src=Path(row['file']);identity=src.parent.name+'_'+src.stem
    log=out/(identity+'.log');start=time.monotonic()
    if log.exists() and re.search(r'^RESULT ',log.read_text(),re.M):
        text=log.read_text()
    else:
        try:
            r=subprocess.run(['nice','-n','10','./dagx',str(src),str(a.cost),'1',str(a.nodes)],capture_output=True,text=True,timeout=a.seconds,preexec_fn=limits)
            text=r.stdout+r.stderr
        except subprocess.TimeoutExpired as e:
            text=(e.stdout or b'').decode()+(e.stderr or b'').decode()+'\nRESULT TIMEOUT\n'
        log.write_text(text)
    result=re.findall(r'^RESULT (\w+).*$',text,re.M)
    record=dict(file=str(src),log=str(log),status=result[-1] if result else 'ERROR',seconds=round(time.monotonic()-start,3),node_limit=a.nodes,cost=a.cost)
    calls=re.findall(r'calls=(\d+)',text)
    if calls:record['calls']=int(calls[-1])
    if record['status']=='FOUND':
        body=text.split('\nSOLUTION ',1)[1].split('\n',1)[1].split('\nEND')[0]
        prog=Path('programs')/(a.tag+'_'+identity+'.s')
        prog.write_text('# n=5 R=40 iset=I1 model=out source=w8_router\n'+body+'\n')
        v=subprocess.run(['nice','-n','10','python3','src/verify_log.py',str(prog),prog.stem],capture_output=True,text=True)
        check=v.stdout+v.stderr
        passed=check.count('PASS ')==2
        if not passed:
            repaired=prog.with_name(prog.stem+'_repaired.s')
            try:
                fix=subprocess.run(['nice','-n','10','python3','src/repair_ties.py',str(prog),str(repaired)],capture_output=True,text=True,timeout=45)
                check+=fix.stdout+fix.stderr
                if repaired.exists():
                    v=subprocess.run(['nice','-n','10','python3','src/verify_log.py',str(repaired),repaired.stem],capture_output=True,text=True)
                    check+=v.stdout+v.stderr;passed=v.stdout.count('PASS ')==2
                    if passed:prog=repaired
            except subprocess.TimeoutExpired:
                check+='TIE_REPAIR TIMEOUT\n'
        (out/(identity+'.judge.log')).write_text(check)
        record.update(program=str(prog),judge=check,verified=passed)
        if not passed:record['status']='REJECTED'
    return record
with (out/'results.jsonl').open('a') as f:
    with concurrent.futures.ThreadPoolExecutor(max_workers=a.jobs) as pool:
        for r in pool.map(run,manifest):
            print(json.dumps(r),flush=True);f.write(json.dumps(r)+'\n');f.flush()
