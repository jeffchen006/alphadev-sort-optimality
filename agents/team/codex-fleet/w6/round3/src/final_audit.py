"""Check retained hashes and logs without repeating solver or judge runs."""
import hashlib
import json
import os
from pathlib import Path

p = Path('round3/artifacts/final_summary.json')
summary = json.loads(p.read_text())
for row in summary['strict_ledger']:
    source,retained,mem = map(Path,(row['source'],row['retained'],row['memory']))
    assert source.read_bytes() == retained.read_bytes()
    assert hashlib.sha256(retained.read_bytes()).hexdigest() == row['out_sha256']
    assert hashlib.sha256(mem.read_bytes()).hexdigest() == row['mem_sha256']
    assert Path(row['out_log']).read_text().startswith('PASS '+str(source)+' ')
    assert Path(row['mem_log']).read_text().startswith('PASS '+str(mem)+' ')
controls = json.loads(Path('round3/artifacts/duplicate_min_control_ledger.json').read_text())
for row in controls:
    assert row['pass'] and Path(row['log']).read_text().startswith('PASS '+row['path']+' ')
    row['sha256'] = hashlib.sha256(Path(row['path']).read_bytes()).hexdigest()
summary['duplicate_min_control'] = controls
summary['near_miss_analysis'] = json.loads(Path('round3/artifacts/near14_analysis.json').read_text())
summary['bounded_jobs'] = len(summary['jobs'])
summary['solver_queries'] = sum(any('satrep.py' in arg or 'source_slots_sat.py' in arg or
    'triple_copy.py' in arg or 'triple_free.py' in arg for arg in row['command']) for row in summary['jobs'])
summary['cpu_affinity_at_final_audit'] = sorted(os.sched_getaffinity(0))
assert len(summary['cpu_affinity_at_final_audit']) == 2
assert not Path('round3/artifacts/FOUND_PENDING').exists()
assert Path('RESULTS.md').read_text().count('## Round 3 completion') == 1
p.write_text(json.dumps(summary,indent=2))
print(json.dumps({'strict_out_and_mem':len(summary['strict_ledger']),
                  'control_out_and_mem':len(controls)//2,
                  'solver_queries':summary['solver_queries'],'bounded_jobs':summary['bounded_jobs'],
                  'cpu_affinity':summary['cpu_affinity_at_final_audit'],'audit':'match'}),flush=True)
