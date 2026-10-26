import argparse, concurrent.futures, json, os, resource, signal, subprocess, time
from pathlib import Path

def run(job):
    name,limit,args=job
    command=['nice','-n','10','python3','-B','src/search.py',*args]
    start=time.monotonic()
    def setup():
        resource.setrlimit(resource.RLIMIT_AS,(4*1024**3,4*1024**3))
        os.setsid()
    with open('logs/'+name+'.log','w') as f:
        p=subprocess.Popen(command,stdout=f,stderr=subprocess.STDOUT,preexec_fn=setup)
        status='finished'
        try:p.wait(timeout=limit)
        except subprocess.TimeoutExpired:
            status='timeout';os.killpg(p.pid,signal.SIGTERM);p.wait()
    result={'name':name,'command':command,'limit':limit,'seconds':time.monotonic()-start,'exit':p.returncode,'status':status}
    Path('artifacts/'+name+'.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result),flush=True)
    return result

if __name__=='__main__':
    ap=argparse.ArgumentParser();ap.add_argument('jobs');ap.add_argument('--workers',type=int,default=6);a=ap.parse_args()
    jobs=json.loads(Path(a.jobs).read_text())
    with concurrent.futures.ThreadPoolExecutor(max_workers=a.workers) as pool:
        list(pool.map(run,jobs))
