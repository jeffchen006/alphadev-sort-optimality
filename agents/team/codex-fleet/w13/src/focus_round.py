"""One-core continuation: proof check, SAT cuts, then low-column sources."""
import collections,hashlib,json,os,resource,subprocess,time
from pathlib import Path
from resume_wave import command
from run import digest
PROJECT=Path('/path/to/repo')

def proofcheck():
    cnf=Path('logs/fixed_far_c9_31.cnf');proof=Path('logs/fixed_far_c9_31.drat')
    solve=command([str(PROJECT/'bin/kissat'),'--time=60',str(cnf),str(proof)],'fixed_far_c9_31_proofsolve',75)
    # SAT solver return 20 is its UNSAT exit code, so command status is ERROR.
    if solve['returncode']!=20:return
    check=command([str(PROJECT/'bin/drat-trim'),str(cnf),str(proof)],'fixed_far_c9_31_proofcheck',90)
    text=Path(check['log']).read_text();verified='s VERIFIED' in text and check['returncode']==0
    record=dict(formula=str(cnf),formula_sha256=hashlib.sha256(cnf.read_bytes()).hexdigest(),proof=str(proof),proof_sha256=hashlib.sha256(proof.read_bytes()).hexdigest(),verified=verified,solver=solve,checker=check)
    Path('logs/fixed_far_c9_31.certificate.json').write_text(json.dumps(record,indent=2)+'\n')
    if verified:
        source='sk/resume_c9_p2_4_6_m1/s000034.txt';mf=[json.loads(l) for l in Path('sk/resume_all.jsonl').read_text().splitlines()];row=next(r for r in mf if r['file']==source)
        sha=digest(source)
        rec=dict(**row,sha256=sha,k=31,status='NONE',node_limit=0,mode='SAT',calls=0,cpu_seconds=0,log=str(cnf),certificate='logs/fixed_far_c9_31.certificate.json')
        folder=Path('logs/sat31');folder.mkdir(exist_ok=True)
        (folder/'results.jsonl').open('a').write(json.dumps(rec)+'\n')
        Path('closed.txt').open('a').write(sha+'\n');Path('logs/closed.jsonl').open('a').write(json.dumps(rec)+'\n')

def main():
    if os.nice(0)<10:os.nice(10-os.nice(0))
    resource.setrlimit(resource.RLIMIT_AS,(4*1024**3,4*1024**3))
    while not Path('logs/round3_report.stage.json').exists():time.sleep(1)
    command(['g++','-O3','-std=c++17','src/generate_focus.cpp','-o','generate_focus'],'focus_compile',90)
    command(['python3','src/fixed_sat_cuts.py','sk/c8_full6/s000000.txt','--k','34','--cases','120','--seconds','20','--fixed','programs/audit_c8_first_c8_k34.s','--tag','cuts_control34'],'cuts_control34',50)
    control=json.loads(Path('logs/cuts_control34.json').read_text())
    if control['status']!='SATISFIABLE' or not all(r['passed'] for r in control['verification']):raise RuntimeError('cut control failed')
    proofcheck()
    for file,tag in [('sk/round3_c9_p2_4_6_m0/s000479.txt','cuts_far7_c9_31'),('sk/resume_c8_p3_5_6_m2/s000008.txt','cuts_far6_c8_31')]:
        command(['python3','src/fixed_sat_cuts.py',file,'--k','31','--cases','120','--seconds','75','--tag',tag],tag,100)
    combined=Path('sk/resume_combined.keys')
    plan=[(8,'1,3,6',0,16,417),(8,'2,4,6',0,16,831),(8,'3,5,6',0,16,174),(8,'2,5,7',0,16,242),(9,'2,4,6',0,17,711),(9,'3,5',0,17,417),(9,'2,4',0,17,831),(9,'1,3,5',0,17,174)]
    folders=[]
    for c,positions,mode,req,seed in plan:
        tag=f'focus_c{c}_p{positions.replace(",","_")}_m{mode}_s{seed}';folder=Path('sk',tag);folders.append(folder)
        os.environ.update(GEN_REQCAP=str(req),GEN_SEED=str(seed))
        command(['./generate_focus',str(c),positions,str(mode),str(folder),'500',str(combined)],tag,45)
        with combined.open('a') as out:
            for p in sorted(folder.glob('*.key')):out.write(p.read_text())
        print(json.dumps(dict(generation=tag,records=sum(1 for _ in (folder/'manifest.jsonl').open()))),flush=True)
    command(['./distance','sk/prior_full.keys','sk/focus_distance.jsonl',*[str(p) for p in folders]],'focus_distance',120)
    distances={r['file']:r for r in map(json.loads,Path('sk/focus_distance.jsonl').read_text().splitlines())}
    rows=[]
    for folder in folders:
        for line in (folder/'manifest.jsonl').read_text().splitlines():
            r=json.loads(line);r.update({k:v for k,v in distances[r['file']].items() if k!='file'});rows.append(r)
    Path('sk/focus_all.jsonl').write_text(''.join(json.dumps(r)+'\n' for r in rows))
    selected=[r for r in rows if r['distance']>=3]
    Path('sk/focus_selected.jsonl').write_text(''.join(json.dumps(r)+'\n' for r in selected))
    print(json.dumps(dict(generated=len(rows),selected=len(selected),distances=dict(collections.Counter(str((r['c'],r['distance'])) for r in rows)))),flush=True)
    if selected:
        command(['python3','src/audit.py','sk/focus_selected.jsonl','--tag','focus_audit'],'focus_audit',120)
        command(['python3','src/run.py','focus31','sk/focus_selected.jsonl','--limit','100000','--timeout','30'],'focus_route31')
    # A changed traversal only for low-column, far cases not closed elsewhere.
    command(['python3','src/report.py'],'focus_before_deep_report')
    distance={}
    for fn in ['sk/first_distance.jsonl','sk/resume_distance.jsonl','sk/round3_distance.jsonl','sk/focus_distance.jsonl']:
        for line in Path(fn).read_text().splitlines():
            r=json.loads(line);distance[r['file']]=r['distance']
    opens=json.loads(Path('sk/open_cases.json').read_text());priority=[]
    for r in opens:
        r['distance']=distance.get(r['file'],0)
        if r['distance']>=4 and r['required']<=17 and r['node_limit']<1000000:priority.append(r)
    priority.sort(key=lambda r:(r['required']+r['c'],-r['distance'],-r['nonlattice'],r['file']))
    # Keep both comparison counts in the final deep pass.
    chosen=[r for r in priority if r['c']==8][:100]+[r for r in priority if r['c']==9][:100]
    Path('sk/focus_deep_selected.jsonl').write_text(''.join(json.dumps(r)+'\n' for r in chosen))
    if chosen:command(['python3','src/run.py','focus_deep31','sk/focus_deep_selected.jsonl','--mode','1','--limit','1000000','--timeout','15'],'focus_deep31')
    command(['python3','src/report.py'],'focus_final_report')
    print('FOCUS_ROUND_COMPLETE',flush=True)

if __name__=='__main__':main()
