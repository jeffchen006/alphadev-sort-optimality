"""One sequential search job; bounded child processes; resumable ledgers."""
from pathlib import Path
import collections,hashlib,json,os,resource,subprocess,time

resource.setrlimit(resource.RLIMIT_AS,(2800*1024*1024,)*2)
os.environ.update(OMP_NUM_THREADS='1',OPENBLAS_NUM_THREADS='1',PYTHONDONTWRITEBYTECODE='1')

def events(path):
    result=[]
    for line in Path(path).read_text().splitlines():
        try:result.append(json.loads(line))
        except ValueError:pass
    return result

def run_one(name,command,wall,extra):
    log=Path('round8/logs',name+'.log')
    before=resource.getrusage(resource.RUSAGE_CHILDREN);t=time.monotonic()
    print(json.dumps(dict(step='starting',name=name,command=command,wall_limit=wall)),flush=True)
    with log.open('w') as f:
        r=subprocess.run(['timeout','--signal=TERM','--kill-after=3s',str(wall)+'s','nice','-n','19',*command],stdout=f,stderr=subprocess.STDOUT)
    after=resource.getrusage(resource.RUSAGE_CHILDREN)
    row=dict(name=name,command=command,log=str(log),exit=r.returncode,wall_seconds=time.monotonic()-t,
             cpu_seconds=after.ru_utime+after.ru_stime-before.ru_utime-before.ru_stime,
             peak_child_rss_kib=after.ru_maxrss,**extra)
    return row

satplan=json.loads(Path('round8/artifacts/smallest40_plan.json').read_text())
seeds=json.loads(Path('round6/artifacts/near_inventory.json').read_text())['representatives']
satpath=Path('round8/artifacts/sat_ledger.json');mcmcpath=Path('round8/artifacts/mcmc_ledger.json')
satledger=json.loads(satpath.read_text()) if satpath.exists() else []
mcmcledger=json.loads(mcmcpath.read_text()) if mcmcpath.exists() else []
satdone={r['prior_name'] for r in satledger};mcmcdone={r['name'] for r in mcmcledger}
mcmcplan=[dict(seed=i,temperature=temp,seconds=40,random_seed=830100+100*ti+i)
          for ti,temp in enumerate((0.25,0.8,2.4)) for i in range(15)]
planpath=Path('round8/artifacts/mcmc_plan.json')
if not planpath.exists() or len(json.loads(planpath.read_text()))<len(mcmcplan):
    planpath.write_text(json.dumps(mcmcplan,indent=2))

for index in range(max(len(satplan),len(mcmcplan))):
    if Path('round8/artifacts/FOUND').exists():break
    if index<len(satplan):
        old=satplan[index];name='long_'+old['name'];out=Path('round8/candidates',name+'.s')
        if old['name'] not in satdone:
            cmd=['python3','-B','round8/src/window.py',old['source'],str(out),'--binary',
                 '--start',str(old['start']),'--width',str(old['width']),'--fresh','1','--seconds','900']
            if old['typed']:cmd.append('--typed')
            if '--covered-windows' in old['command']:cmd.append('--covered-windows')
            row=run_one(name,cmd,910,dict(kind='sat',prior_name=old['name'],seed=old['seed'],source=old['source'],
                         start=old['start'],width=old['width'],typed=old['typed'],prior_clauses=old['last_clauses'],prior_variables=old['last_variables']))
            ev=events(row['log']);fin=[e for e in ev if e.get('step')=='finished']
            row['status']=fin[-1]['status'] if fin else 'UNKNOWN' if row['exit']==124 else 'ERROR'
            row['events']=ev
            row['cuts']=next((e.get('covered',[]) for e in ev if e.get('step')=='initial_cases'),[])
            satledger.append(row);satpath.write_text(json.dumps(satledger,indent=2))
            if out.exists():subprocess.run(['nice','-n','19','python3','-B','round8/src/verify.py',str(out)],check=True)
            print(json.dumps(dict(step='sat_done',done=len(satledger),total=40,last=name,status=row['status'],counts=dict(collections.Counter(r['status'] for r in satledger)))),flush=True)
    if Path('round8/artifacts/FOUND').exists():break
    if index<len(mcmcplan):
        p=mcmcplan[index];i=p['seed'];name=f"failure_s{i:02d}_t{p['temperature']}"
        if name in mcmcdone:continue
        prefix=Path('round8/candidates',name)
        cmd=['round8/bin/failure_search',seeds[i]['file'],str(prefix),'31',str(p['temperature']),
             '0',str(p['seconds']),str(p['random_seed']),'10','0']
        row=run_one(name,cmd,300,dict(kind='mcmc',**p,source=seeds[i]['file']))
        summary=[l for l in Path(row['log']).read_text().splitlines() if l.startswith('SUMMARY ')]
        row['status']=('FINISHED_AT_WALL_LIMIT' if row['exit']==124 else 'FINISHED') if summary else 'INCOMPLETE'
        if summary:
            row['summary']={}
            for field in summary[-1].split()[1:]:
                k,v=field.split('=');row['summary'][k]=float(v) if '.' in v else int(v)
        row['saved_le6']=[str(f) for f in sorted(prefix.parent.glob(name+'_le6_*.s'))]
        mcmcledger.append(row);mcmcpath.write_text(json.dumps(mcmcledger,indent=2))
        candidates=list(prefix.parent.glob(name+'_k*.s'))+list(prefix.parent.glob(name+'_structure_*.s'))
        for f in candidates:subprocess.run(['nice','-n','19','python3','-B','round8/src/verify.py',str(f)],check=True)
        for f in map(Path,row['saved_le6']):
            subprocess.run(['nice','-n','19','python3','-B','round8/src/verify.py',str(f)],check=True)
        print(json.dumps(dict(step='mcmc_done',done=len(mcmcledger),total=len(mcmcplan),last=name,status=row['status'],summary=row.get('summary'),saved_le6=len(row['saved_le6']))),flush=True)

print(json.dumps(dict(step='batch_finished',sat_done=len(satledger),mcmc_done=len(mcmcledger),found=Path('round8/artifacts/FOUND').exists())),flush=True)
