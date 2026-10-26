"""Read-only audit of retained scopes, solver statuses, hashes and judge logs."""
from collections import Counter
import hashlib
import json
from pathlib import Path

ROOT=Path(__file__).resolve().parents[2]
BASE=ROOT/'round5'


def digest(path):
    h=hashlib.sha256()
    with Path(path).open('rb') as f:
        while b:=f.read(1024**2):h.update(b)
    return h.hexdigest()


def audit():
    tasks=json.loads((BASE/'logs/tasks.json').read_text())
    rows=json.loads((BASE/'logs/summary.json').read_text()) if (BASE/'logs/summary.json').exists() else []
    controls=json.loads((BASE/'logs/controls.json').read_text())
    assert len(tasks)==352 and len({t['tag'] for t in tasks})==352
    planned={t['tag']:t for t in tasks}
    original=json.loads((ROOT/'round4/repair/tasks.json').read_text())
    for old in original:
        new=planned[old['tag']]
        assert new['window']==old['window'] and new['registers']==old['registers']
        assert digest(old['seed'])==new['seed_sha256']
    seeds={t['seed']:t['seed_sha256'] for t in tasks}
    for path,sha in seeds.items():assert digest(path)==sha
    assert controls[0]['status']=='PASS' and controls[0]['k']==32
    assert controls[1]['status']=='UNSAT' and controls[1]['certificate']['verified']
    checked=0
    all_passes=[]
    for row in controls+rows:
        if row in rows:assert row['task']==planned[row['tag']]
        if row['status']=='UNSAT':
            solver=next(e for e in reversed(row['records']) if e.get('step')=='kissat')
            assert solver['returncode']==20 and solver['status']=='UNSAT'
            certificate=row['certificate'];assert certificate['verified'] and certificate['returncode']==0
            cnf=Path(certificate['cnf']);assert digest(cnf)==certificate['cnf_sha256']==solver['cnf_sha256']
            assert digest(cnf.with_suffix('.drat'))==certificate['proof_sha256']
            assert 's VERIFIED' in (BASE/'logs'/f'{row["tag"]}.verify.log').read_text()
            checked+=1
        for event in row['records']:
            if event.get('step')=='model_judge':
                assert Path(event['path']+'.judge').read_text()==event['output']
                if event['returncode']==0:
                    assert event['output'].startswith('PASS ')
                    all_passes.append(event)
        for judge in row['judges']:
            assert digest(judge['path'])==judge['sha256']
            assert Path(judge['log']).read_text()==judge['output']
            if judge['returncode']==0:
                assert judge['output'].startswith('PASS ')
                all_passes.append(judge)
    result=dict(planned=len(tasks),completed=len(rows),pending=len(tasks)-len(rows),
                statuses=dict(Counter(r['status'] for r in rows)),
                verified_unsat_including_negative_control=checked,
                strict_passes=all_passes,seed_hashes_checked=len(seeds),
                assumptions=['G1','G2','G3','G4','A2','A11'])
    (BASE/'logs/independent_audit.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result))
    return result


if __name__=='__main__':audit()
