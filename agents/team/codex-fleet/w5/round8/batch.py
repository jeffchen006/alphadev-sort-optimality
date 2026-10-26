"""Run median-chain window queries sequentially and retain complete statuses."""
from pathlib import Path
import argparse
from collections import Counter
import hashlib,json,os,resource,signal,subprocess,sys,time
sys.dont_write_bytecode=True
HERE=Path(__file__).resolve().parent

def save(path,value):
    temp=path.with_suffix(path.suffix+'.tmp');temp.write_text(json.dumps(value,indent=2)+'\n');temp.replace(path)

def events(path):
    rows=[]
    for line in path.read_text().splitlines():
        try:rows.append(json.loads(line))
        except ValueError:pass
    return rows

def main():
    ap=argparse.ArgumentParser();ap.add_argument('--seconds',type=float,default=1200);ap.add_argument('--max-queries',type=int,default=1720)
    args=ap.parse_args();assert os.getpriority(os.PRIO_PROCESS,0)==19
    os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
    resource.setrlimit(resource.RLIMIT_AS,(2800*1024**2,2800*1024**2))
    queue=json.loads((HERE/'queue.json').read_text());path=HERE/'results.json'
    results=json.loads(path.read_text()) if path.exists() else []
    done={(r['seed'],r['start']) for r in results};began=time.monotonic();count=0
    for order,row in enumerate(queue):
        seed,start=row['seed'],row['start']
        if (seed,start) in done:continue
        tag=f'seed{seed:03d}_window{start:02d}';log=HERE/'logs'/f'{tag}.log';out=HERE/'candidates'/f'{tag}.s'
        command=['nice','-n','19',sys.executable,'-B',str(HERE/'window_repair.py'),str(seed),str(start),str(out),'--seconds',str(args.seconds)]
        started=time.monotonic();active=dict(row,queue_order=order,command=command,wall_limit=args.seconds,started_unix=time.time())
        with log.open('w') as stream:
            process=subprocess.Popen(command,stdout=stream,stderr=subprocess.STDOUT,start_new_session=True)
            active['pid']=process.pid;save(HERE/'active.json',active)
            print(json.dumps(dict(step='start',**active)),flush=True)
            try:code=process.wait(timeout=args.seconds+60)
            except subprocess.TimeoutExpired:
                os.killpg(process.pid,signal.SIGTERM)
                try:process.wait(timeout=5)
                except subprocess.TimeoutExpired:os.killpg(process.pid,signal.SIGKILL);process.wait()
                code=124
        parsed=events(log);terminal=next((x for x in reversed(parsed) if 'status' in x),{})
        status=terminal.get('status','UNKNOWN_OUTER_LIMIT' if code==124 else 'ERROR')
        result=dict(row,queue_order=order,status=status,code=code,seconds=time.monotonic()-started,
                    log=str(log),command=command,last=terminal,
                    solver_calls=sum(x.get('step')=='kissat_result' for x in parsed),
                    log_sha256=hashlib.sha256(log.read_bytes()).hexdigest())
        if status=='CANDIDATE':
            judged=subprocess.run(['nice','-n','19',sys.executable,'-B',str(HERE/'verify.py'),str(out)],capture_output=True,text=True)
            (HERE/'logs'/f'{tag}_judge.log').write_text(judged.stdout+judged.stderr)
            result['strict_pass']=judged.returncode==0
        results.append(result);save(path,results)
        save(HERE/'progress.json',dict(planned=len(queue),finished=len(results),remaining=len(queue)-len(results),
              status_counts=dict(Counter(r['status'] for r in results)),elapsed_this_run=time.monotonic()-began,all_jobs_finished=False))
        (HERE/'active.json').unlink(missing_ok=True)
        print(json.dumps(dict(step='result',**result)),flush=True)
        count+=1
        if result.get('strict_pass') or count>=args.max_queries:break
    save(HERE/'progress.json',dict(planned=len(queue),finished=len(results),remaining=len(queue)-len(results),
          status_counts=dict(Counter(r['status'] for r in results)),elapsed_this_run=time.monotonic()-began,all_jobs_finished=True))
if __name__=='__main__':main()
