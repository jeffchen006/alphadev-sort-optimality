"""Audit the Kissat retry ledger without changing earlier round records."""
from collections import Counter
import json
from pathlib import Path

from round2 import digest
from round4 import report


def main():
    selection = json.loads(Path('round4/selection.json').read_text())
    prior = json.loads(Path('round3/final_summary.json').read_text())
    old_selection = json.loads(Path('round3/selection.json').read_text())
    result = report()
    jobs = selection['jobs']
    assert jobs == sorted(jobs, key=lambda j: (j['clauses'], j['variables'], j['index']))
    assert {tuple(j['window']) for j in jobs} == {tuple(w) for w in prior['penta']['unknown_windows']}
    assert len(jobs) == 161
    rows = []
    formula_hashes = certificate_hashes = 0
    generation_seconds = 0
    generations_peak = 0
    for job in jobs:
        prefix = job['prefix']
        assert old_selection['windows'][job['index']] == job['window']
        metadata = json.loads(Path(prefix + '.s.mapping.json').read_text())
        generation_seconds += metadata['generation_resources']['seconds']
        generations_peak = max(generations_peak, metadata['generation_resources']['peak_KiB'])
        assert metadata['generation_resources']['exit'] == 0
        assert metadata['registers'] == 8 and metadata['free'] == job['window']
        assert (metadata['variables'], metadata['clauses']) == (job['variables'], job['clauses'])
        assert len(metadata['cases']) == 128
        record = Path(prefix + '.json')
        if not record.exists():
            continue
        row = json.loads(record.read_text())
        assert row['window'] == job['window'] and row['index'] == job['index']
        assert row['registers'] == 8 and row['limit_seconds'] == 900
        assert row['status'] in ('UNSAT', 'UNKNOWN', 'PASS')
        if row['status'] == 'UNSAT':
            assert row['proof_verified']
            assert digest(prefix + '.s.cnf') == row['cnf_sha256']
            assert digest(prefix + '.drat') == row['drat_sha256']
            assert 's VERIFIED' in Path(prefix + '.verify.log').read_text()
            assert row['attempts'][-1]['exit'] == 20
            formula_hashes += 1
            certificate_hashes += 1
        if not row['blocked_mappings']:
            assert digest(prefix + '.s.cnf') == metadata['initial_cnf_sha256']
        if row['status'] == 'PASS':
            assert 'PASS ' in Path(row['file'] + '.judge.log').read_text()
        rows.append(row)
    offset = 0
    families = []
    closed_indices = {r['index'] for r in rows if r['status'] == 'UNSAT'}
    for family in old_selection['families']:
        indices = set(range(offset, offset + family['distinct_added']))
        retry_jobs = [j for j in jobs if j['index'] in indices]
        completed = [r for r in rows if r['index'] in indices]
        families.append({**family, 'selected_retries': len(retry_jobs),
                         'completed_retries': len(completed),
                         'retry_statuses': dict(Counter(r['status'] for r in completed))})
        offset += family['distinct_added']
    assert offset == 189
    pending_indices = {j['index'] for j in jobs} - {r['index'] for r in rows}
    unknown_indices = {r['index'] for r in rows if r['status'] == 'UNKNOWN'}
    result.update(families=families, generation_seconds=generation_seconds,
                  generation_peak_KiB=generations_peak,
                  unresolved_windows=[old_selection['windows'][i] for i in sorted(pending_indices | unknown_indices)],
                  new_closed_windows=[old_selection['windows'][i] for i in sorted(closed_indices)],
                  selection_sha256=digest('round4/selection.json'),
                  source_hashes={str(p): digest(p) for p in [Path('src/round4.py'), Path('src/round4_report.py'),
                      Path('src/search.py'), Path('src/binary_encode.py'), Path('src/encode.py'),
                      Path('src/reference_window.py'), Path('src/round3.py'), Path('src/round2.py')]},
                  ledger_audit={'status': 'MATCH', 'records': len(rows),
                                'formula_hashes': formula_hashes, 'certificate_hashes': certificate_hashes})
    executed = Path('round4/controller_executed.py')
    if executed.exists():
        result['executed_controller_sha256'] = digest(executed)
    Path('round4/final_summary.json').write_text(json.dumps(result, indent=2) + '\n')
    print(json.dumps(result), flush=True)


if __name__ == '__main__':
    main()
