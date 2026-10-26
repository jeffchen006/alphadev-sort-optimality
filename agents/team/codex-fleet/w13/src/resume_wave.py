"""Bounded serial continuation. Retain all partial source-generation records."""
import collections,json,os,resource,subprocess,time
from pathlib import Path

def command(args,tag,seconds=None):
    log=Path('logs',tag+'.runlog')
    start=time.monotonic()
    with log.open('w') as out:
        try:
            p=subprocess.run(args,stdout=out,stderr=subprocess.STDOUT,timeout=seconds)
            status='COMPLETE' if p.returncode==0 else 'ERROR'
            rc=p.returncode
        except subprocess.TimeoutExpired:status='TIMEOUT';rc=124
    record=dict(command=args,status=status,returncode=rc,wall_seconds=time.monotonic()-start,log=str(log))
    Path('logs',tag+'.stage.json').write_text(json.dumps(record,indent=2)+'\n')
    print(json.dumps(record),flush=True)
    return record

def main():
    if os.nice(0)<10:os.nice(10-os.nice(0))
    resource.setrlimit(resource.RLIMIT_AS,(4*1024**3,4*1024**3))
    # Prior deep cases have their own durable ledger. Do not repeat them here.
    command(['python3','src/audit.py','sk/c9_full4/manifest.jsonl','--tag','audit_c9_first'],'resume_audit_c9',180)
    command(['./distance','sk/prior_full.keys','sk/first_distance.jsonl','sk/c8_full6','sk/c9_full4'],'resume_distance_first',180)
    for k,sec,fixed,tag in [(34,20,'programs/audit_c8_first_c8_k34.s','sat_positive34'),(31,60,None,'sat_target31')]:
        if Path('logs',tag+'.json').exists():continue
        cmd=['python3','src/column_sat.py','sk/c8_full6/s000000.txt','--k',str(k),'--cases','24','--seconds',str(sec),'--tag',tag]
        if fixed:cmd+=['--fixed',fixed]
        r=command(cmd,tag,sec+60)
        if r['status']!='COMPLETE':break
        if fixed:
            rec=json.loads(Path('logs',tag+'.json').read_text())
            if rec['status']!='SATISFIABLE' or not rec.get('verification') or not all(x['passed'] for x in rec['verification']):break
    combined=Path('sk/resume_combined.keys')
    if not combined.exists():
        with combined.open('w') as out:
            out.write(Path('sk/prior_full.keys').read_text())
            for folder in ['c8_full6','c9_full4']:
                for p in sorted(Path('sk',folder).glob('*.key')):out.write(p.read_text())
    plan=[(8,'2',0,3000),(8,'3',0,3000),(8,'4,6',2,3000),(8,'3,6',2,3000),(8,'3,5,6',2,3000),(9,'3,5',1,1500),(9,'4,6',1,1500),(9,'2,4,6',1,1500),(8,'4',0,3000),(9,'5',0,1500)]
    folders=[]
    for c,positions,mode,cap in plan:
        tag=f'resume_c{c}_p{positions.replace(",","_")}_m{mode}'
        folder=Path('sk',tag);folders.append(folder)
        if Path('logs',tag+'.stage.json').exists():continue
        command(['./generate',str(c),positions,str(mode),str(folder),str(cap),str(combined)],tag,120)
        if folder.exists():
            with combined.open('a') as out:
                for p in sorted(folder.glob('*.key')):out.write(p.read_text())
        n=sum(1 for _ in (folder/'manifest.jsonl').open()) if (folder/'manifest.jsonl').exists() else 0
        print(json.dumps(dict(generation=tag,records=n)),flush=True)
    command(['./distance','sk/prior_full.keys','sk/resume_distance.jsonl',*[str(p) for p in folders]],'resume_distance_wave',300)
    distance={r['file']:r for r in map(json.loads,Path('sk/resume_distance.jsonl').read_text().splitlines())}
    rows=[]
    for folder in folders:
        for l in (folder/'manifest.jsonl').read_text().splitlines():
            r=json.loads(l);r.update({k:v for k,v in distance[r['file']].items() if k!='file'});rows.append(r)
    Path('sk/resume_all.jsonl').write_text(''.join(json.dumps(r)+'\n' for r in rows))
    selected=[r for r in rows if r['c']==8 or r['distance']>=3]
    selected.sort(key=lambda r:(r['required']+r['c'],-r['distance'],r['file']))
    Path('sk/resume_selected.jsonl').write_text(''.join(json.dumps(r)+'\n' for r in selected))
    print(json.dumps(dict(generated=len(rows),selected=len(selected),distances=dict(collections.Counter(str((r['c'],r['distance'])) for r in rows)))),flush=True)
    command(['python3','src/audit.py','sk/resume_selected.jsonl','--tag','resume_source_audit'],'resume_source_audit',300)
    command(['python3','src/run.py','resume31','sk/resume_selected.jsonl','--limit','100000','--timeout','30'],'resume_route31')
    command(['python3','src/report.py'],'resume_report')

if __name__=='__main__':main()
