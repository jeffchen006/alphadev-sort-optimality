"""Six sequential bounded jobs. Retain parameters and strict judge results."""
from pathlib import Path
import hashlib,json,os,re,resource,subprocess,time

resource.setrlimit(resource.RLIMIT_AS,(2800*1024*1024,)*2)
os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
os.environ.update(OMP_NUM_THREADS='1',OPENBLAS_NUM_THREADS='1',PYTHONDONTWRITEBYTECODE='1')
ROOT=Path.cwd().parents[3]
inv=json.loads(Path('round6/artifacts/near_inventory.json').read_text())['representatives']
plan=[]
for index,(representative,temperature,weights) in enumerate(((0,2,(4,2,4)),(2,4,(8,2,6)),(10,8,(16,4,8)))):
    for mode,seconds in [('out',600),('mem',120)]:
        name=f'weighted_{mode}_s{representative:02d}'
        source=inv[representative]['file' if mode=='out' else 'source']
        command=['round9/bin/weighted',source,'round9/candidates/'+name,mode,str(seconds),str(952600+100*index+(mode=='mem')),str(temperature),*map(str,weights),'2']
        plan.append(dict(name=name,mode=mode,source=source,source_sha256=hashlib.sha256(Path(source).read_bytes()).hexdigest(),cpu_limit=seconds,wall_limit=6*seconds+60,temperature=temperature,weights=weights,command=command))
Path('round9/artifacts/plan.json').write_text(json.dumps(plan,indent=2))
ledgerpath=Path('round9/artifacts/ledger.json')
ledger=json.loads(ledgerpath.read_text()) if ledgerpath.exists() else []
for p in plan:
    if Path('round9/artifacts/FOUND').exists():break
    if any(r['name']==p['name'] for r in ledger):continue
    log=Path('round9/logs',p['name']+'.log')
    before=resource.getrusage(resource.RUSAGE_CHILDREN);began=time.monotonic()
    print(json.dumps(dict(step='starting',**p)),flush=True)
    with log.open('w') as f:
        r=subprocess.run(['timeout','--signal=TERM','--kill-after=5s',str(p['wall_limit'])+'s','nice','-n','19',*p['command']],stdout=f,stderr=subprocess.STDOUT)
    after=resource.getrusage(resource.RUSAGE_CHILDREN)
    row=dict(**p,exit=r.returncode,log=str(log),wall_seconds=time.monotonic()-began,cpu_seconds=after.ru_utime+after.ru_stime-before.ru_utime-before.ru_stime,peak_child_rss_kib=after.ru_maxrss,affinity=sorted(os.sched_getaffinity(0)))
    summary=[l for l in log.read_text().splitlines() if l.startswith('SUMMARY ')]
    row['status']='COMPLETE' if summary and r.returncode==0 else 'FINISHED_AT_WALL_LIMIT' if summary and r.returncode==124 else 'INCOMPLETE'
    if summary:
        row['summary']={k:float(v) if '.' in v else int(v) for k,v in (s.split('=') for s in summary[-1].split()[1:])}
    row['judges']=[]
    candidates=sorted(Path('round9/candidates').glob(p['name']+'*.s'))
    for path in candidates:
        jlog=Path('round9/logs',path.stem+'_'+p['mode']+'_judge.log')
        with jlog.open('w') as f:
            judge=subprocess.run(['nice','-n','19','python3','-B',str(ROOT/'shared/judge.py'),str(path),'--strict','--model',p['mode']],stdout=f,stderr=subprocess.STDOUT)
        passed=judge.returncode==0 and 'PASS ' in jlog.read_text()
        row['judges'].append(dict(file=str(path),model=p['mode'],passed=passed,log=str(jlog)))
        if passed:
            retained=Path('round9/verified_mem' if p['mode']=='mem' else 'round9/verified',path.name);retained.write_bytes(path.read_bytes())
            if p['mode']=='out':
                subprocess.run(['nice','-n','19','python3','-B','round9/src/verify.py',str(path)],check=True)
            else:
                length=sum(1 for l in path.read_text().splitlines() if l and not l.startswith('#'))
                line=f'FOUND k<={length-10} mem={retained} strict mem PASS; out conversion pending\n'
                result=Path('RESULTS.md');result.write_text(line+result.read_text());Path('round9/artifacts/FOUND').write_text(line)
    ledger.append(row);ledgerpath.write_text(json.dumps(ledger,indent=2))
    print(json.dumps(dict(step='done',name=p['name'],status=row['status'],summary=row.get('summary'),judged=len(row['judges']))),flush=True)
print(json.dumps(dict(step='finished',runs=len(ledger),found=Path('round9/artifacts/FOUND').exists())),flush=True)
