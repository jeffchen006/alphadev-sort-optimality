"""Run at most two single-threaded bounded SAT jobs and retain exact status."""
from pathlib import Path
import concurrent.futures,hashlib,itertools,json,subprocess,sys,time
HERE=Path(__file__).resolve().parent
sys.dont_write_bytecode=True
sys.path.insert(0,str(HERE.parent/'round4/src'))
from flag_sat import OPS
sys.path.insert(0,'/path/to/repo/agents/team/codex-fleet/w6/src')
from window_sat import read

def canonical(path):
    p,_=read(str(path));best=None
    # Renaming inputs and scratch registers preserves the repair neighborhood.
    # Reverse comparison operands and all predicates in that comparison block.
    for perm in itertools.permutations(range(5)):
        mp=dict(enumerate(perm));key=[];flip=False
        for o,d,s in p:
            for r in (d,s):
                if r not in mp:mp[r]=len(mp)
            a,b=mp[d],mp[s]
            if o==1:
                flip=a>b
                if flip:a,b=b,a
            elif o>=2 and flip:o={2:4,3:5,4:2,5:3}[o]
            key.extend((o,a,b))
        key=tuple(key)
        if best is None or key<best:best=key
    return best

def run(row):
    start=time.monotonic();path=Path(row['file']);tag=path.stem
    log=HERE/'logs'/f'sat_{tag}.log';output=HERE/'candidates'/f'{tag}_repair.s'
    cmd=['nice','-n','19',sys.executable,'-B',str(HERE/'sat_repair.py'),str(path),str(output),'--meta',row['meta']]
    with log.open('w') as f:
        try:
            done=subprocess.run(cmd,stdout=f,stderr=subprocess.STDOUT,timeout=120)
            code=done.returncode;status='ERROR'
        except subprocess.TimeoutExpired:code=None;status='UNKNOWN_WALL_LIMIT'
    events=[]
    for line in log.read_text().splitlines():
        try:events.append(json.loads(line))
        except ValueError:pass
    if code==0:status=next((x['status'] for x in reversed(events) if 'status'in x),'ERROR')
    result=dict(file=str(path),failures=row['failures'],status=status,seconds=time.monotonic()-start,limit=120,code=code,log=str(log),command=cmd,last=events[-1] if events else None)
    print(json.dumps(result),flush=True)
    if status=='CANDIDATE':
        check=subprocess.run(['nice','-n','19',sys.executable,'-B',str(HERE/'verify.py'),str(output)],capture_output=True,text=True)
        (HERE/'logs'/f'verify_{tag}.log').write_text(check.stdout+check.stderr)
        result['strict_pass']=check.returncode==0
    return result

if __name__=='__main__':
    rows=json.loads((HERE/'near_manifest.json').read_text());groups={}
    for row in rows:groups.setdefault(canonical(row['file']),[]).append(row)
    queries=[v[0] for v in groups.values()]
    (HERE/'repair_classes.json').write_text(json.dumps(list(groups.values()),indent=2)+'\n')
    results=[]
    with concurrent.futures.ThreadPoolExecutor(max_workers=2) as pool:
        for result in pool.map(run,queries):
            results.append(result);(HERE/'sat_results.json').write_text(json.dumps(results,indent=2)+'\n')
    print(json.dumps(dict(done=True,programs=len(rows),classes=len(groups),queries=len(results))))
