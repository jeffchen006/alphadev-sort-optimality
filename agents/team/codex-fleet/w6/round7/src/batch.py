"""One sequential CPU job. Each query has a separate wall and RAM limit."""
from pathlib import Path
import collections,hashlib,json,os,resource,subprocess,sys,time
HERE=Path(__file__).resolve().parents[2];ROOT=HERE.parents[3]
sys.path[:0]=[str(HERE/'round7/src'),str(HERE/'src'),str(ROOT/'agents/sat'),str(HERE/'round3/src')]
from window import analyze
from window_sat import read

resource.setrlimit(resource.RLIMIT_AS,(2800*1024*1024,)*2)
os.environ.update(OMP_NUM_THREADS='1',OPENBLAS_NUM_THREADS='1',PYTHONDONTWRITEBYTECODE='1')
rows=json.loads(Path('round6/artifacts/near_inventory.json').read_text())['representatives']
analyses=[]
for i,row in enumerate(rows):
    p,nr=read(row['file']);a=analyze(p,nr)
    a.update(seed=i,source=row['file'],sha256=hashlib.sha256(Path(row['file']).read_bytes()).hexdigest())
    analyses.append(a)
Path('round7/artifacts/path_analysis.json').write_text(json.dumps(analyses,indent=2))

# Slide from the middle merge back through the prefix, then through the suffix.
# The order uses the traced median dependencies; it does not discard any start.
starts=[12,13,14,15,16,11,10,9,8,7,6,5,4,3,2,1,0,17,18,19,20,21,22,23,24,25]
plan=[]
for width in (7,8):
    for i,row in enumerate(rows):
        plan.append(dict(seed=i,start=12,width=width,typed=True,seconds=12))
for start in starts:
    for i,row in enumerate(rows):
        if i==0 and start==12:continue # already completed in t00_w6_i12.log
        plan.append(dict(seed=i,start=start,width=6,typed=True,seconds=8))
for i,row in enumerate(rows):
    plan.append(dict(seed=i,start=12,width=6,typed=False,seconds=18))
Path('round7/artifacts/query_plan.json').write_text(json.dumps(plan,indent=2))
ledger=[];began=time.monotonic()
for query in plan:
    i=query['seed'];s=query['start'];w=query['width'];typed=query['typed']
    name=f'{"typed" if typed else "full"}_s{i:02d}_w{w}_i{s:02d}'
    out=Path('round7/candidates',name+'.s');log=Path('round7/logs',name+'.log')
    cmd=['python3','-B','round7/src/window.py',rows[i]['file'],str(out),'--binary',
         '--start',str(s),'--width',str(w),'--fresh','1','--seconds',str(query['seconds'])]
    if typed:cmd.append('--typed')
    t=time.monotonic();u0=resource.getrusage(resource.RUSAGE_CHILDREN)
    with log.open('w') as f:
        r=subprocess.run(['timeout','--signal=TERM','--kill-after=2s',str(query['seconds']+8)+'s','nice','-n','19',*cmd],stdout=f,stderr=subprocess.STDOUT)
    u1=resource.getrusage(resource.RUSAGE_CHILDREN)
    events=[]
    for line in log.read_text().splitlines():
        try:events.append(json.loads(line))
        except ValueError:pass
    status=next((e['status'] for e in reversed(events) if e.get('step')=='finished'), 'ERROR' if r.returncode not in (0,124) else 'UNKNOWN')
    record=dict(query,name=name,source=rows[i]['file'],command=cmd,log=str(log),exit=r.returncode,status=status,
                seconds=time.monotonic()-t,cpu_seconds=u1.ru_utime+u1.ru_stime-u0.ru_utime-u0.ru_stime,peak_rss_kib=u1.ru_maxrss,
                cases=next((e.get('cases') for e in reversed(events) if 'cases' in e),None))
    ledger.append(record)
    Path('round7/artifacts/query_ledger.json').write_text(json.dumps(ledger,indent=2))
    if out.exists():
        subprocess.run(['nice','-n','19','python3','-B','round7/src/verify.py',str(out)],check=True)
    counts=dict(collections.Counter(r['status'] for r in ledger))
    print(json.dumps(dict(done=len(ledger),total=len(plan),last=name,status=status,counts=counts,seconds=time.monotonic()-began)),flush=True)
    if Path('round7/artifacts/FOUND').exists():break
print(json.dumps(dict(status='BATCH_FINISHED',counts=counts,seconds=time.monotonic()-began)),flush=True)
