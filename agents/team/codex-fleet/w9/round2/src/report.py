"""Collect exact query counters, source hashes, and strict judge records."""
from collections import Counter
import hashlib
import json
from pathlib import Path
from orders import HERE

def main():
    batches=[];latest={}
    for file in sorted((HERE/'artifacts').glob('*.jsonl')):
        rows=[json.loads(line) for line in file.read_text().splitlines() if line.strip()]
        for row in rows:
            key=(row['family'],tuple(row['order']),row['k'],row['regs'],row.get('prefix_length',0),
                 tuple(row.get('positions') or ()),row.get('polarity',False),row.get('source',''))
            latest[key]=row
        batches.append({'file':str(file),'queries':len(rows),
                        'status':dict(Counter(r['status'] for r in rows)),
                        'cpu':sum(r['cpu'] for r in rows),
                        'registers':sorted({r['regs'] for r in rows}),
                        'prefix_lengths':dict(Counter(r.get('prefix_length',0) for r in rows)),
                        'cegis_candidates':sum(r['iterations'] for r in rows)})
    first=[json.loads(line) for name in ('prefix_pilot.jsonl','prefix_all.jsonl')
           for line in (HERE/'artifacts'/name).read_text().splitlines() if line.strip()]
    indices=[r['index'] for r in first]
    assert len(indices)==len(set(indices)), 'duplicate first-pass query'
    order_data=json.loads((HERE/'artifacts/orders.json').read_text())
    ledger_path=HERE/'artifacts/strict_ledger.json'
    ledger=json.loads(ledger_path.read_text()) if ledger_path.exists() else []
    files=sorted(list((HERE/'src').glob('*.py'))+[HERE.parent/'src/encode.py',HERE.parent/'src/triple_encode.py'])
    hashes={str(path):hashlib.sha256(path.read_bytes()).hexdigest() for path in files}
    source_paths={row['source'] for row in first}
    source_hashes={path:hashlib.sha256(Path(path).read_bytes()).hexdigest() for path in sorted(source_paths)}
    result={'batches':batches,'first_pass_unique_orders':len(indices),
            'first_pass_indices_complete':set(indices)==set(range(653)),
            'first_pass_status':dict(Counter(r['status'] for r in first)),
            'source_flag_sequences':order_data['source_flag_sequences'],
            'families':len(order_data['families']),
            'valid_family_order_pairs':sum(len(r['valid_flag_orders']) for r in order_data['families']),
            'new_family_order_pairs':sum(len(r['new_flag_orders']) for r in order_data['families']),
            'checks':json.loads((HERE/'artifacts/checks.json').read_text()),
            'symmetry':{k:v for k,v in json.loads((HERE/'artifacts/symmetry.json').read_text()).items() if k!='families'},
            'resources':{'cpu_jobs_at_once':1,'cpu_affinity':'84','nice':19,'address_space_limit_mib':2800},
            'latest_unique_queries':len(latest),'latest_unique_status':dict(Counter(r['status'] for r in latest.values())),
            'snapshot_audit':json.loads((HERE/'artifacts/snapshot_audit.json').read_text()) if (HERE/'artifacts/snapshot_audit.json').exists() else [],
            'strict_audit_counts':dict(Counter('PASS' if r['pass'] else 'FAIL' for r in ledger)),
            'strict_ledger':ledger,'hashes':hashes,'source_hashes':source_hashes}
    (HERE/'artifacts/final_summary.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({k:v for k,v in result.items() if k not in ('hashes','strict_ledger','source_hashes')}),flush=True)

if __name__=='__main__':main()
