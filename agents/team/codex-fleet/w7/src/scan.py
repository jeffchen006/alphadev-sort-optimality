"""Split an arbitrary-position SAT window into independent finite jobs."""
import argparse, concurrent.futures, hashlib, itertools, json, os, resource, signal, subprocess, threading, time
from pathlib import Path

gate=threading.Condition()
active=0
dynamic=False

def capacity():
    if not dynamic:return 8
    try:
        one=json.loads(Path('artifacts/batch1.json').read_text())
        two=json.loads(Path('artifacts/batch2.json').read_text())
    except (OSError,json.JSONDecodeError):
        # A partial control-file update must not cancel queued search jobs.
        return 0
    pending_one=sum(not Path(f'artifacts/{job[0]}.json').exists() for job in one)
    pending_two=any(not Path(f'artifacts/{job[0]}.json').exists() for job in two)
    audit=not Path('artifacts/pairs_proof_audit.json').exists()
    return max(0,8-pending_one-int(pending_two)-int(audit))

def task(job):
    global active
    with gate:
        while active>=capacity():gate.wait(timeout=1)
        active+=1
    try:return execute(job)
    finally:
        with gate:active-=1;gate.notify_all()

def execute(job):
    name,free,registers,limit,extra=job
    cmd=['nice','-n','10','python3','-B','src/search.py','seeds/near31.s',f'candidates/{name}.s','--changes','0','--registers',str(registers),'--free',','.join(map(str,free)),*extra]
    start=time.monotonic()
    def setup():
        resource.setrlimit(resource.RLIMIT_AS,(3*1024**3,3*1024**3));os.setsid()
    with open(f'logs/{name}.log','w') as f:
        p=subprocess.Popen(cmd,stdout=f,stderr=subprocess.STDOUT,preexec_fn=setup)
        try:p.wait(timeout=limit);status='finished'
        except subprocess.TimeoutExpired:os.killpg(p.pid,signal.SIGTERM);p.wait();status='timeout'
    text=Path(f'logs/{name}.log').read_text()
    if '"status": "UNSAT"' in text:status='UNSAT'
    if '"status": "PASS"' in text:status='PASS'
    result={'name':name,'free':free,'registers':registers,'status':status,'exit':p.returncode,'seconds':time.monotonic()-start,'command':cmd}
    if status=='UNSAT' and '--proof' in extra:
        cnf=Path(f'candidates/{name}.s.cnf');proof=Path(f'candidates/{name}.s.drat')
        with open(f'logs/{name}.verify.log','w') as f:
            checked=subprocess.run(['nice','-n','10','/path/to/repo/agents/proofs/tools/bin/drat-trim',str(cnf),str(proof)],stdout=f,stderr=subprocess.STDOUT)
        result['proof_verified']=checked.returncode==0 and 's VERIFIED' in Path(f'logs/{name}.verify.log').read_text()
        result['cnf_sha256']=hashlib.sha256(cnf.read_bytes()).hexdigest()
        result['drat_sha256']=hashlib.sha256(proof.read_bytes()).hexdigest()
    Path(f'artifacts/{name}.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result),flush=True)
    return result

if __name__=='__main__':
    ap=argparse.ArgumentParser();ap.add_argument('kind',choices=['pairs','triples','groups']);ap.add_argument('--workers',type=int,default=2);ap.add_argument('--seconds',type=float,default=20);ap.add_argument('--registers',type=int,default=11);ap.add_argument('--first',type=int,default=0);ap.add_argument('--last',type=int,default=9999);ap.add_argument('--proof',action='store_true');ap.add_argument('--dynamic',action='store_true');ap.add_argument('--resume',action='store_true');a=ap.parse_args()
    dynamic=a.dynamic
    width=2 if a.kind=='pairs' else 3
    free=list(itertools.combinations(range(31),width))
    if a.kind=='groups':free=json.loads(Path('artifacts/groups.json').read_text())
    extra=['--proof'] if a.proof else []
    jobs=[(a.kind+'_'+str(i).zfill(4),list(f),a.registers,a.seconds,extra) for i,f in enumerate(free) if a.first<=i<a.last]
    if a.resume:jobs=[job for job in jobs if not Path(f'artifacts/{job[0]}.json').exists()]
    with concurrent.futures.ThreadPoolExecutor(max_workers=a.workers) as pool:
        list(pool.map(task,jobs))
