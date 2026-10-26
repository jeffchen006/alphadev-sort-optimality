"""Longer refinements of unresolved slots near the incorrect value writes."""
from pathlib import Path
import json,subprocess,sys,time
HERE=Path(__file__).resolve().parent
chosen=[('near9',13,20),('near9',15,20),('near14',13,20),('near14',14,20)]
results=[]
for seed,a,b in chosen:
    prior=[]
    for path in HERE.glob(seed+'_slots_*.json'):prior.extend(json.loads(path.read_text()))
    old=next((x for x in prior if x['slots']==[a,b]),None)
    assert old is not None,(seed,a,b)
    if old['status']!='UNKNOWN_WALL_LIMIT':
        results.append(dict(seed=seed,slots=[a,b],status='SKIPPED_ALREADY_COMPLETE',prior_status=old['status']));continue
    tag=f'{seed}_all541_{a}_{b}';log=HERE/'logs'/f'{tag}.log';out=HERE/'candidates'/f'{tag}.s'
    cmd=['nice','-n','19',sys.executable,'-B',str(HERE/'sat_repair.py'),str(HERE/'seeds'/f'{seed}.s'),str(out),'--meta',str(HERE/'seeds'/f'{seed}.json'),'--predicates','--slots',f'{a},{b}','--all-cases']
    began=time.monotonic();code=None
    with log.open('w') as f:
        try:
            proc=subprocess.run(cmd,stdout=f,stderr=subprocess.STDOUT,timeout=60);code=proc.returncode;status='ERROR'
        except subprocess.TimeoutExpired:status='UNKNOWN_WALL_LIMIT'
    events=[]
    for line in log.read_text().splitlines():
        try:events.append(json.loads(line))
        except ValueError:pass
    if code==0:status=next((x['status']for x in reversed(events)if 'status'in x),'ERROR')
    row=dict(seed=seed,slots=[a,b],status=status,seconds=time.monotonic()-began,wall_limit=60,code=code,log=str(log),command=cmd,last=events[-1]if events else None)
    if status=='CANDIDATE':
        proc=subprocess.run(['nice','-n','19',sys.executable,'-B',str(HERE/'verify.py'),str(out)],capture_output=True,text=True)
        (HERE/'logs'/f'{tag}_judge.log').write_text(proc.stdout+proc.stderr);row['strict_pass']=proc.returncode==0
    results.append(row);(HERE/'focused_results.json').write_text(json.dumps(results,indent=2)+'\n');print(json.dumps(row),flush=True)
(HERE/'focused_results.json').write_text(json.dumps(results,indent=2)+'\n')
print(json.dumps(dict(done=True,planned=len(chosen),records=len(results))))
