import argparse, hashlib, json, subprocess, time
from pathlib import Path

CHECKER='/path/to/repo/agents/proofs/tools/bin/drat-trim'

if __name__=='__main__':
    ap=argparse.ArgumentParser();ap.add_argument('--pattern',default='pairs_*.s.cnf');ap.add_argument('--name',default='pairs');a=ap.parse_args()
    rows=[];start=time.monotonic()
    for cnf in sorted(Path('candidates').glob(a.pattern)):
        proof=cnf.with_suffix('.drat');log=Path('logs')/(cnf.stem+'.verify.log')
        with log.open('w') as f:
            result=subprocess.run(['nice','-n','10',CHECKER,str(cnf),str(proof)],stdout=f,stderr=subprocess.STDOUT)
        ok=result.returncode==0 and 's VERIFIED' in log.read_text()
        rows.append({'cnf':str(cnf),'drat':str(proof),'verified':ok,'cnf_sha256':hashlib.sha256(cnf.read_bytes()).hexdigest(),'drat_sha256':hashlib.sha256(proof.read_bytes()).hexdigest()})
        if not ok:print(json.dumps(rows[-1]),flush=True)
        if len(rows)%50==0:print(json.dumps({'checked':len(rows),'seconds':time.monotonic()-start}),flush=True)
    summary={'checked':len(rows),'verified':sum(row['verified'] for row in rows),'seconds':time.monotonic()-start,'checker':CHECKER,'rows':rows}
    Path(f'artifacts/{a.name}_proof_audit.json').write_text(json.dumps(summary,indent=2)+'\n')
    print(json.dumps({k:v for k,v in summary.items() if k!='rows'}),flush=True)
