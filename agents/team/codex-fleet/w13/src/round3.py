"""Serial search for distant structures with unrestricted conditional actions."""
import collections,json,os,resource,time
from pathlib import Path
from resume_wave import command

def main():
    if os.nice(0)<10:os.nice(10-os.nice(0))
    resource.setrlimit(resource.RLIMIT_AS,(4*1024**3,4*1024**3))
    command(['python3','src/audit_weak.py','sk/resume_selected.jsonl','--tag','resume_weak_audit'],'resume_weak_audit',120)
    command(['python3','src/audit.py','sk/resume_selected.jsonl','--layouts','--tag','resume_layout_audit'],'resume_layout_audit',180)
    control=json.loads(Path('logs/fixed_control34.json').read_text())
    if control['status']!='SATISFIABLE' or not all(x['passed'] for x in control['verification']):raise RuntimeError('control failed')
    for file,tag in [('sk/resume_c8_p3_5_6_m2/s000008.txt','fixed_far_c8_31'),('sk/resume_c9_p2_4_6_m1/s000034.txt','fixed_far_c9_31')]:
        command(['python3','src/fixed_sat.py',file,'--k','31','--cases','120','--seconds','90','--tag',tag],tag,115)
    combined=Path('sk/resume_combined.keys')
    plan=[(8,'1',0,1500),(8,'8',0,1500),(8,'2,5',0,1500),(8,'3,6',0,1500),(8,'4,6',0,1500),(8,'3,5',0,1500),(8,'2,4,6',1,1500),(8,'1,3,6',1,1500),(9,'1',0,1000),(9,'2',0,1000),(9,'3',0,1000),(9,'3,6',0,1000),(9,'4,6',0,1000),(9,'2,4,6',0,1000)]
    folders=[]
    for c,positions,mode,cap in plan:
        tag=f'round3_c{c}_p{positions.replace(",","_")}_m{mode}';folder=Path('sk',tag);folders.append(folder)
        if Path('logs',tag+'.stage.json').exists():continue
        command(['./generate',str(c),positions,str(mode),str(folder),str(cap),str(combined)],tag,60)
        if folder.exists():
            with combined.open('a') as out:
                for p in sorted(folder.glob('*.key')):out.write(p.read_text())
        print(json.dumps(dict(generation=tag,records=sum(1 for _ in (folder/'manifest.jsonl').open()))),flush=True)
    command(['./distance','sk/prior_full.keys','sk/round3_distance.jsonl',*[str(p) for p in folders]],'round3_distance',180)
    distances={r['file']:r for r in map(json.loads,Path('sk/round3_distance.jsonl').read_text().splitlines())}
    rows=[]
    for folder in folders:
        for line in (folder/'manifest.jsonl').read_text().splitlines():
            r=json.loads(line);r.update({k:v for k,v in distances[r['file']].items() if k!='file'});rows.append(r)
    Path('sk/round3_all.jsonl').write_text(''.join(json.dumps(r)+'\n' for r in rows))
    selected=[r for r in rows if r['c']==8 or r['distance']>=3]
    Path('sk/round3_selected.jsonl').write_text(''.join(json.dumps(r)+'\n' for r in selected))
    print(json.dumps(dict(generated=len(rows),selected=len(selected),distances=dict(collections.Counter(str((r['c'],r['distance'])) for r in rows)))),flush=True)
    command(['python3','src/audit.py','sk/round3_selected.jsonl','--tag','round3_audit'],'round3_audit',180)
    command(['python3','src/audit_weak.py','sk/round3_selected.jsonl','--tag','round3_weak_audit'],'round3_weak_audit',180)
    command(['python3','src/run.py','round3_31','sk/round3_selected.jsonl','--limit','100000','--timeout','30'],'round3_route31')
    command(['python3','src/report.py'],'round3_report')

if __name__=='__main__':main()
