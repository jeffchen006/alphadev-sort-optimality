"""Audit the round-three ledger and summarize distinct windows."""
from collections import Counter
import json
from math import comb
from pathlib import Path

from round3 import digest, select, summary


def run():
    selection = select()
    best, result = summary(selection)
    rows = [json.loads(p.read_text()) for p in sorted(Path('round3').glob('*_[0-9][0-9][0-9][0-9]_*.json'))]
    model_count = 0
    judge_calls = 0
    for row in rows:
        prefix = f"round3/{row['kind']}_{row['index']:04d}_{row['attempt']}"
        judge_calls += Path(prefix + '.s.judge.log').exists()
        for line in Path(prefix + '.log').read_text().splitlines():
            try:
                model_count += json.loads(line).get('step') == 'candidate'
            except json.JSONDecodeError:
                pass
        windows = selection['quad_retry_windows'] if row['kind'] == 'quad' else selection['windows']
        assert row['window'] == windows[row['index']], row
        assert row['registers'] == 8, row
        assert row['status'] in ('UNSAT', 'UNKNOWN', 'PASS'), row
        if row['status'] == 'UNSAT':
            assert row['proof_verified'], row
            assert digest(prefix + '.s.cnf') == row['cnf_sha256'], row
            assert digest(prefix + '.s.drat') == row['drat_sha256'], row
            assert 's VERIFIED' in Path(prefix + '.verify.log').read_text(), row
    prior = json.loads(Path('round2/final_summary.json').read_text())
    closed = sum(r['status'] == 'UNSAT' and r.get('proof_verified') for (kind, _), r in best.items() if kind == 'quad')
    result['combined_four_position_scope'] = {
        'selected': prior['selected'],
        'checked_UNSAT': prior['checked_UNSAT_windows'] + closed,
        'UNKNOWN': len(prior['unknown_windows']) - closed,
        'scope': prior['scope']}
    offset = 0
    families = []
    for family in selection['families']:
        indices = range(offset, offset + family['distinct_added'])
        these = [best['penta', i] for i in indices if ('penta', i) in best]
        families.append({**family, 'processed': len(these),
                         'statuses': dict(Counter(r['status'] for r in these)),
                         'checked_UNSAT': sum(r.get('proof_verified', False) for r in these)})
        offset += family['distinct_added']
    assert offset == len(selection['windows'])
    result['penta_families_disjoint'] = families
    result['attempt_groups'] = []
    groups = sorted({(r['kind'], r['attempt']) for r in rows})
    for kind, attempt in groups:
        these = [r for r in rows if r['kind'] == kind and r['attempt'] == attempt]
        result['attempt_groups'].append({'kind': kind, 'attempt': attempt, 'queries': len(these),
            'statuses': dict(Counter(r['status'] for r in these)),
            'limits_seconds': sorted({r['limit_seconds'] for r in these}),
            'all_541_initial_case_queries': sum('--all-cases' in r['command'] for r in these),
            'binary_encoder_queries': sum('--binary' in r['command'] for r in these)})
    result['scope'] = selection['scope']
    result['unselected_five_position_windows'] = comb(31, 5) - len(selection['windows'])
    result['solver_models'] = model_count
    result['strict_judge_calls'] = judge_calls
    result['selection_sha256'] = digest('round3/selection.json')
    result['source_hashes']['src/round3_report.py'] = digest('src/round3_report.py')
    for helper in ['src/round2.py', 'src/reference_window.py']:
        result['source_hashes'][helper] = digest(helper)
    result['ledger_audit'] = {'status': 'MATCH', 'records': len(rows),
                              'checked_formula_and_certificate_hashes': sum(r['status'] == 'UNSAT' for r in rows)}
    Path('round3/final_summary.json').write_text(json.dumps(result, indent=2) + '\n')
    print(json.dumps(result), flush=True)


if __name__ == '__main__':
    run()
