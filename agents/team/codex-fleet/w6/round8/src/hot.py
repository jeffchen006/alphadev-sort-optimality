"""Additional high-temperature restarts. Run only after the main batch ends."""
from pathlib import Path
import json,os,resource,subprocess,time
resource.setrlimit(resource.RLIMIT_AS,(2800*1024*1024,)*2)
os.environ.update(OMP_NUM_THREADS='1',OPENBLAS_NUM_THREADS='1',PYTHONDONTWRITEBYTECODE='1')
seeds=json.loads(Path('round6/artifacts/near_inventory.json').read_text())['representatives']
path=Path('round8/artifacts/mcmc_ledger.json');ledger=json.loads(path.read_text())
assert len(ledger)>=45
assert len(json.loads(Path('round8/artifacts/sat_ledger.json').read_text()))==40
done={r['name'] for r in ledger}
planpath=Path('round8/artifacts/mcmc_plan.json');plan=json.loads(planpath.read_text())
if len(plan)==45:
    plan += [dict(seed=i,temperature=8,seconds=40,random_seed=831000+i) for i in range(15)]
    planpath.write_text(json.dumps(plan,indent=2))
for i,seed in enumerate(seeds):
    if Path('round8/artifacts/FOUND').exists():break
    name=f'failure_s{i:02d}_t8'
    if name in done:continue
    prefix=Path('round8/candidates',name);log=Path('round8/logs',name+'.log')
    cmd=['round8/bin/failure_search',seed['file'],str(prefix),'31','8','0','40',str(831000+i),'10','0']
    print(json.dumps(dict(step='starting',name=name,command=cmd,wall_limit=300)),flush=True)
    t=time.monotonic();u0=resource.getrusage(resource.RUSAGE_CHILDREN)
    with log.open('w') as f:
        r=subprocess.run(['timeout','--signal=TERM','--kill-after=3s','300s','nice','-n','19',*cmd],stdout=f,stderr=subprocess.STDOUT)
    u1=resource.getrusage(resource.RUSAGE_CHILDREN)
    summary=[l for l in log.read_text().splitlines() if l.startswith('SUMMARY ')]
    row=dict(name=name,kind='mcmc',seed=i,temperature=8,seconds=40,random_seed=831000+i,source=seed['file'],
             command=cmd,log=str(log),exit=r.returncode,wall_seconds=time.monotonic()-t,
             cpu_seconds=u1.ru_utime+u1.ru_stime-u0.ru_utime-u0.ru_stime,peak_child_rss_kib=u1.ru_maxrss,
             status=('FINISHED_AT_WALL_LIMIT' if r.returncode==124 else 'FINISHED') if summary else 'INCOMPLETE')
    if summary:
        row['summary']={}
        for field in summary[-1].split()[1:]:
            k,v=field.split('=');row['summary'][k]=float(v) if '.' in v else int(v)
    row['saved_le6']=[str(p) for p in sorted(prefix.parent.glob(name+'_le6_*.s'))]
    ledger.append(row);path.write_text(json.dumps(ledger,indent=2))
    for f in list(prefix.parent.glob(name+'_k*.s'))+list(prefix.parent.glob(name+'_structure_*.s'))+list(map(Path,row['saved_le6'])):
        subprocess.run(['nice','-n','19','python3','-B','round8/src/verify.py',str(f)],check=True)
    print(json.dumps(dict(step='mcmc_done',done=len(ledger),total=60,last=name,status=row['status'],summary=row.get('summary'),saved_le6=len(row['saved_le6']))),flush=True)
print(json.dumps(dict(step='hot_finished',mcmc=len(ledger))),flush=True)
