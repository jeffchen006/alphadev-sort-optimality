"""Independent LRAT certificate run for the distant SAT-negative skeleton."""
import hashlib,json,os,resource,time
from pathlib import Path
from resume_wave import command
from run import digest
PROJECT=Path('/path/to/repo')

def main():
    if os.nice(0)<10:os.nice(10-os.nice(0))
    resource.setrlimit(resource.RLIMIT_AS,(4*1024**3,4*1024**3))
    while not Path('logs/focus_final_report.stage.json').exists():time.sleep(1)
    cnf=Path('logs/cuts_far7_c9_31.cnf');proof=Path('logs/cuts_far7_c9_31.lrat')
    solver=command([str(PROJECT/'bin/cadical'),'--lrat','--no-binary','--checkproof=0','-t','120',str(cnf),str(proof)],'cuts_far7_c9_31_lratsolve',135)
    record=dict(formula=str(cnf),formula_sha256=hashlib.sha256(cnf.read_bytes()).hexdigest(),proof=str(proof),verified=False,solver=solver)
    if proof.exists():record['proof_sha256']=hashlib.sha256(proof.read_bytes()).hexdigest()
    if solver['returncode']==20:
        checker=command([str(PROJECT/'bin/lrat-check'),str(cnf),str(proof)],'cuts_far7_c9_31_lratcheck',90)
        log=Path(checker['log']).read_text();record['checker']=checker
        record['verified']=checker['returncode']==0 and 'VERIFIED' in log
    cert=Path('logs/cuts_far7_c9_31.certificate.json');cert.write_text(json.dumps(record,indent=2)+'\n')
    if record['verified']:
        source='sk/round3_c9_p2_4_6_m0/s000479.txt';row=next(r for r in map(json.loads,Path('sk/round3_selected.jsonl').read_text().splitlines()) if r['file']==source)
        sha=digest(source);rec=dict(row,sha256=sha,k=31,status='NONE',node_limit=0,mode='SAT',calls=0,cpu_seconds=0,log=str(cnf),certificate=str(cert))
        folder=Path('logs/sat31');folder.mkdir(exist_ok=True);(folder/'results.jsonl').open('a').write(json.dumps(rec)+'\n')
        Path('closed.txt').open('a').write(sha+'\n');Path('logs/closed.jsonl').open('a').write(json.dumps(rec)+'\n')
    command(['python3','src/report.py'],'certificate_report')
    print(json.dumps(record),flush=True)

if __name__=='__main__':main()
