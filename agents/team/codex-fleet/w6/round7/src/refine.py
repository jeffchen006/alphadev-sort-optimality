"""Wider windows containing the median selects, using completed local cuts."""
from pathlib import Path
import collections,json,os,resource,subprocess,time
resource.setrlimit(resource.RLIMIT_AS,(2800*1024*1024,)*2)
os.environ.update(OMP_NUM_THREADS='1',OPENBLAS_NUM_THREADS='1',PYTHONDONTWRITEBYTECODE='1')
seeds=json.loads(Path('round6/artifacts/near_inventory.json').read_text())['representatives']
primary=json.loads(Path('round7/artifacts/query_ledger.json').read_text())
assert len(primary)==len(json.loads(Path('round7/artifacts/query_plan.json').read_text()))
ledger=[];began=time.monotonic()
for width in (7,8):
    for i,row in enumerate(seeds):
        name=f'refined_s{i:02d}_w{width}_i14';out=Path('round7/candidates',name+'.s');log=Path('round7/logs',name+'.log')
        cmd=['python3','-B','round7/src/window.py',row['file'],str(out),'--start','14','--width',str(width),
             '--binary','--typed','--fresh','1','--seconds','20','--covered-windows']
        t=time.monotonic();u0=resource.getrusage(resource.RUSAGE_CHILDREN)
        with log.open('w') as f:
            r=subprocess.run(['timeout','--signal=TERM','--kill-after=2s','28s','nice','-n','19',*cmd],stdout=f,stderr=subprocess.STDOUT)
        u1=resource.getrusage(resource.RUSAGE_CHILDREN)
        events=[]
        for line in log.read_text().splitlines():
            try:events.append(json.loads(line))
            except ValueError:pass
        finish=[e for e in events if e.get('step')=='finished']
        status=finish[-1]['status'] if finish else 'UNKNOWN' if r.returncode==124 else 'ERROR'
        ledger.append(dict(seed=i,source=row['file'],start=14,width=width,typed=True,name=name,command=cmd,log=str(log),
                           seconds=time.monotonic()-t,cpu_seconds=u1.ru_utime+u1.ru_stime-u0.ru_utime-u0.ru_stime,
                           peak_rss_kib=u1.ru_maxrss,status=status,exit=r.returncode,
                           cases=next((e['cases'] for e in reversed(events) if 'cases' in e),None),
                           cuts=next((e['covered'] for e in events if e.get('step')=='initial_cases'),[])))
        Path('round7/artifacts/refined_ledger.json').write_text(json.dumps(ledger,indent=2))
        if out.exists():subprocess.run(['nice','-n','19','python3','-B','round7/src/verify.py',str(out)],check=True)
        print(json.dumps(dict(done=len(ledger),total=30,last=name,status=status,counts=dict(collections.Counter(r['status'] for r in ledger)),seconds=time.monotonic()-began)),flush=True)
        if Path('round7/artifacts/FOUND').exists():break
    if Path('round7/artifacts/FOUND').exists():break
print(json.dumps(dict(status='REFINED_BATCH_FINISHED',seconds=time.monotonic()-began)),flush=True)
