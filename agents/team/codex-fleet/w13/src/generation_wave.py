"""Run a serial, reproducible generation wave and extend the exclusion index."""
import json, os, subprocess, time
from pathlib import Path

def main():
    if os.nice(0)<10:os.nice(10-os.nice(0))
    pilots=[
        ['python3','src/column_sat.py','sk/c8_full6/s000000.txt','--k','34','--cases','24','--seconds','20','--fixed','programs/audit_c8_first_c8_k34.s','--tag','sat_positive34'],
        ['python3','src/column_sat.py','sk/c8_full6/s000000.txt','--k','31','--cases','24','--seconds','60','--tag','sat_target31'],
    ]
    for command in pilots:
        tag=command[-1]
        result=subprocess.run(command,capture_output=True,text=True)
        Path('logs',tag+'_driver.log').write_text(result.stdout+result.stderr)
        print(json.dumps(dict(stage=tag,returncode=result.returncode)),flush=True)
        if result.returncode:raise RuntimeError((tag,result.stderr))
        if tag=='sat_positive34':
            check=json.loads(Path('logs/sat_positive34.json').read_text())
            if check['status']!='SATISFIABLE' or not all(r['passed'] for r in check.get('verification',[])):
                print('SAT_POSITIVE_VALIDATION_FAILED; target pilot skipped',flush=True)
                break
    combined=Path('sk/combined.keys')
    if not combined.exists():
        subprocess.run(['./generate','--index','sk/first.keys','sk/c8_full6','sk/c9_full4'],check=True,stdout=Path('logs/first_index.stdout').open('w'),stderr=Path('logs/first_index.log').open('w'))
        combined.write_text(Path('sk/prior.keys').read_text()+Path('sk/first.keys').read_text())
    plan=[
        (8,'2',0,10000),
        (8,'3',0,10000),
        (8,'4,6',2,10000),
        (8,'3,6',2,10000),
        (8,'3,5,6',2,10000),
        (9,'3,5',1,2000),
        (9,'4,6',1,2000),
        (9,'2,4,6',1,2000),
        (8,'4',0,10000),
        (9,'5',0,2000),
    ]
    records=[]
    folders=[]
    for c,positions,mode,cap in plan:
        tag=f'c{c}_p{positions.replace(",", "_")}_m{mode}'
        outdir=Path('sk')/tag
        folders.append(outdir)
        cmd=['./generate',str(c),positions,str(mode),str(outdir),str(cap),str(combined)]
        start=time.monotonic()
        result=subprocess.run(cmd,capture_output=True,text=True)
        Path('logs',f'gen_{tag}.log').write_text(result.stdout+result.stderr)
        if result.returncode:raise RuntimeError((cmd,result.stderr))
        keys=[p.read_text() for p in sorted(outdir.glob('*.key'))]
        with combined.open('a') as f:f.writelines(keys)
        record=dict(command=cmd,wall_seconds=time.monotonic()-start,new_keys=len(keys),output=result.stdout)
        records.append(record);Path('logs/generation_wave.json').write_text(json.dumps(records,indent=2)+'\n')
        print(json.dumps(record),flush=True)
    # The direction asks for structures far from the known families. Preserve
    # all generated records, but route c=9 records only at distance >= 3.
    # All new c=8 records remain eligible. Distance ignores program length.
    result=subprocess.run(['./distance','sk/prior_full.keys','sk/wave_distance.jsonl',*[str(p) for p in folders]],capture_output=True,text=True,check=True)
    Path('logs/distance_wave.log').write_text(result.stdout+result.stderr)
    distances={r['file']:r for r in map(json.loads,Path('sk/wave_distance.jsonl').read_text().splitlines())}
    selected=[];deferred=[];allrows=[]
    for folder in folders:
        mf=folder/'manifest.jsonl';rows=[json.loads(l) for l in mf.read_text().splitlines()]
        (folder/'manifest_all.jsonl').write_text(mf.read_text())
        kept=[]
        for row in rows:
            row.update({k:v for k,v in distances[row['file']].items() if k!='file'})
            allrows.append(row)
            if row['c']==8 or row['distance']>=3:kept.append(row);selected.append(row)
            else:deferred.append(row)
        mf.write_text(''.join(json.dumps(r)+'\n' for r in kept))
    for name,rows in (('wave_all',allrows),('wave_selected',selected),('wave_deferred',deferred)):
        Path('sk',name+'.jsonl').write_text(''.join(json.dumps(r)+'\n' for r in rows))
    print(json.dumps(dict(generated=len(allrows),selected=len(selected),deferred=len(deferred))),flush=True)

if __name__=='__main__':main()
