"""Collect final search counts and file hashes without changing search results."""
import hashlib,json
from collections import Counter
from pathlib import Path

def records(pattern):
    rows=[]
    for path in sorted(Path('artifacts').glob(pattern)):
        row=json.loads(path.read_text())
        log=Path('logs')/(row['name']+'.log')
        if log.exists() and '"status": "SKIPPED"' in log.read_text():row['status']='SKIPPED'
        rows.append(row)
    return rows

pairs=records('pairs_[0-9]*.json');triples=records('triples_[0-9]*.json');retry=records('groups_[0-9]*.json')
audit=json.loads(Path('artifacts/pairs_proof_audit.json').read_text())
target={tuple(row['free']):row for row in triples if set(row['free'])&{14,21}}
for row in retry:
    key=tuple(row['free'])
    if row['status']=='UNSAT' or key not in target:target[key]=row
summary={
 'pairs':{'processed':len(pairs),'statuses':dict(Counter(r['status'] for r in pairs)),'proofs_verified':audit['verified']},
 'triples_first_scan':{'processed':len(triples),'statuses':dict(Counter(r['status'] for r in triples)),'proofs_verified':sum(r.get('proof_verified',False) for r in triples)},
 'triples_retry':{'processed':len(retry),'statuses':dict(Counter(r['status'] for r in retry)),'proofs_verified':sum(r.get('proof_verified',False) for r in retry)},
 'selected_triples':{'windows':len(target),'statuses':dict(Counter(r['status'] for r in target.values())),'proofs_verified':sum(r.get('proof_verified',False) for r in target.values()),'unresolved':[list(key) for key,row in target.items() if row['status']!='UNSAT']},
 'block_reorders':json.loads(Path('artifacts/block_reorders.json').read_text()),
 'inside_reorders':json.loads(Path('artifacts/inside_reorders.json').read_text()),
}
ledger=[]
for path,log,model in [('seeds/repair32.s','logs/repair32_out_judge.log','out'),('candidates/control32.s','candidates/control32.s.judge.log','out'),('verified/repair32_mem.s','logs/repair32_mem_judge.log','mem')]:
    assert 'PASS ' in Path(log).read_text(),log
    code=[line.partition('#')[0].strip() for line in Path(path).read_text().splitlines()]
    k=sum(bool(line) and not line.startswith('out ') for line in code)
    ledger.append({'file':path,'model':model,'length':k,'judge_log':log,'sha256':hashlib.sha256(Path(path).read_bytes()).hexdigest()})
summary['strict_pass_files']=ledger
summary['source_hashes']={str(p):hashlib.sha256(p.read_bytes()).hexdigest() for p in sorted(Path('src').glob('*')) if p.is_file() and p.suffix in ('.py','.cpp')}
Path('artifacts/final_summary.json').write_text(json.dumps(summary,indent=2)+'\n')
print(json.dumps({key:value for key,value in summary.items() if key not in ('source_hashes','block_reorders')},indent=2))
