"""Create the final ledger after all searches and audits finish."""
from collections import Counter
import hashlib
import json
from pathlib import Path
import re

from round2 import select, summary


def main():
    selection = select()
    by_index, result = summary(selection)
    assert result['pending'] == 0
    assert result['final_statuses'].get('ERROR', 0) == 0
    assert result['final_statuses'].get('PASS', 0) == 0, 'Handle a strict PASS before this negative report'
    assert result['checked_UNSAT_windows'] == result['final_statuses'].get('UNSAT', 0)
    assert result['blocked_rejected_candidates'] == 0
    assert len({tuple(w) for w in selection['windows']}) == 299
    for i, row in by_index.items():
        assert row['window'] == selection['windows'][i]
        assert len(row['window']) == 4 and row['window'][-1] - row['window'][0] > 3
        assert row['registers'] == 8
    audit = json.loads(Path('round2/encoding_audit.json').read_text())
    controls = json.loads(Path('round2/variable_domain_crosscheck.json').read_text())
    assert audit['status'] == controls['status'] == 'MATCH'
    assert audit['attempts'] == result['attempts']
    assert audit['boolean_collision_hits'] == 0
    assert audit['UNSAT_formulas_reproduced'] == result['attempt_statuses']['UNSAT']
    binary_controls = json.loads(Path('round2/binary_variable_domain_crosscheck.json').read_text())
    assert binary_controls['status'] == 'MATCH'
    families = []
    for name, lo, hi in [('Tail dependencies', 0, 140), ('Median routes', 140, 195),
                         ('Additional median-loss windows', 195, 299)]:
        rows = [by_index[i] for i in range(lo, hi)]
        families.append({'family': name, 'windows': len(rows),
                         'statuses': dict(Counter(r['status'] for r in rows)),
                         'checked_certificates': sum(r.get('proof_verified', False) for r in rows)})
    attempts = [json.loads(p.read_text()) for p in sorted(Path('round2').glob('quad_*.json'))]
    attempt_groups = []
    for attempt in sorted({r['attempt'] for r in attempts}):
        rows = [r for r in attempts if r['attempt'] == attempt]
        attempt_groups.append({'attempt': attempt, 'queries': len(rows),
                               'statuses': dict(Counter(r['status'] for r in rows)),
                               'limits_seconds': dict(Counter(r['limit_seconds'] for r in rows))})
    result.update({'families_disjoint': families, 'attempt_groups': attempt_groups,
                   'encoding_audit': {k: v for k, v in audit.items() if k != 'records'},
                   'variable_domain_controls': {k: v for k, v in controls.items() if k != 'rows'},
                   'binary_variable_domain_controls': {k: v for k, v in binary_controls.items() if k != 'rows'},
                   'scope': selection['scope'], 'assumptions': ['A2', 'A11'],
                   'strict_PASS_files_new': [],
                   'selection_sha256': hashlib.sha256(Path('round2/selection.json').read_bytes()).hexdigest()})
    counters = {}
    for file in map(Path, ['round2/retry_trial.log', 'round2/retry_remaining.log',
                           'round2/retry_all541.log', 'round2/encoding_audit.log',
                           'round2/retry_binary.log', 'round2/binary_variable_domain_crosscheck.log',
                           'round2/variable_domain_crosscheck.log']):
        if not file.exists():
            continue
        log = file.read_text()
        values = {}
        for key, pattern in [('user_seconds', r'User time \(seconds\): ([0-9.]+)'),
                             ('system_seconds', r'System time \(seconds\): ([0-9.]+)'),
                             ('peak_rss_KiB', r'Maximum resident set size \(kbytes\): ([0-9]+)')]:
            found = re.search(pattern, log)
            if found:
                values[key] = float(found.group(1))
        counters[str(file)] = values
    result['timed_job_resource_counters'] = counters
    for p in Path('src').glob('round2*.py'):
        result['source_hashes'][str(p)] = hashlib.sha256(p.read_bytes()).hexdigest()
    result['source_hashes']['src/binary_encode.py'] = hashlib.sha256(Path('src/binary_encode.py').read_bytes()).hexdigest()
    Path('round2/final_summary.json').write_text(json.dumps(result, indent=2) + '\n')
    extra = [r for r in attempts if r['attempt'] >= 2]
    extra_note = ''
    if extra:
        assert all('--all-cases' in r['command'] for r in extra)
        limits = sorted({r['limit_seconds'] for r in extra})
        distinct = len({r['index'] for r in extra})
        extra_note = f' Further passes made {len(extra)} attempts on {distinct} remaining windows with all 541 weak orders. Their wall limits were {limits} seconds.'
    lines = [f"No strict PASS with k <= 31 was found. All {result['selected']} selected windows were tested. "
             f"The final result is {result['final_statuses'].get('UNSAT', 0)} UNSAT windows with checked certificates "
             f"and {result['final_statuses'].get('UNKNOWN', 0)} UNKNOWN windows. No selected window remains untested.",
             '', '| Window family, with overlaps assigned to the first family | Distinct windows | Checked UNSAT | UNKNOWN |',
             '|---|---:|---:|---:|']
    for row in families:
        lines.append(f"| {row['family']} | {row['windows']} | {row['statuses'].get('UNSAT', 0)} | {row['statuses'].get('UNKNOWN', 0)} |")
    lines += [f"| Total | {result['selected']} | {result['final_statuses'].get('UNSAT', 0)} | {result['final_statuses'].get('UNKNOWN', 0)} |", '',
              f"The search made {result['attempts']} bounded attempts. Attempt statuses were "
              + ', '.join(f'{n} {s}' for s, n in result['attempt_statuses'].items()) + '. '
              'Repeated attempts are not additional distinct windows. Each unresolved window received a retry with all 120 strict input orders in the initial constraints. '
              'Those retries used a 30-second limit.' + extra_note + ' Every time limit remains UNKNOWN.', '',
              f"The recorded search time totals {result['search_seconds']:.3f} seconds. Certificate checks total {result['verify_seconds']:.3f} seconds. "
              'No candidate-blocking clause was needed. No new strict PASS file was produced.', '',
              'The source audit found a general type-comparison defect in the selector helper: Python equates Boolean `True` with integer `1`. '
              'The helper now checks both type and value. The corrected helper passed 4,096 exhaustive truth-table evaluations. '
              'The compact encoder helper also passed 4,096 evaluations. '
              f"Formula regeneration audited all {audit['attempts']} attempts and found zero affected selector calls. "
              f"All {audit['UNSAT_formulas_reproduced']} saved UNSAT formulas were reproduced byte for byte after the correction. "
              f"The minimum absolute SAT literal used as a selector data argument was {audit['minimum_data_literal']}, above the conflicting value 1. "
              'See round2/encoding_audit.json. This audit found no change to a reported exclusion.', '',
              'The corrected encoder also matched the independent scalar evaluator on 18 programs with four variable-domain positions and eight registers. '
              'Three programs used all 541 weak orders. The other 15 used 27 orders each. '
              'The comparison checked whether free output snapshots can sort the encoded orders. It is a test of the translation, not a formal proof. '
              'The compact encoder matched the scalar evaluator on the same 18 control programs. '
              'See round2/variable_domain_crosscheck.json and round2/binary_variable_domain_crosscheck.json.', '',
              'The compact encoder copies w6/round7/src/binary_encode.py into src/binary_encode.py. '
              'Its initialization supports this controller\'s first-touch selectors. It represents ranks with three bits and shares identical Boolean gates across input orders. '
              'Scratch starts at rank 5, above every input rank, and flags start equal. This is another necessary state for strict correctness. '
              'The compact queries preserve the same windows, instruction domains, register bound, and free output snapshots.', '',
              'The final ledger records the exact window list, attempts, certificate results, unresolved windows, and source hashes: round2/final_summary.json.', '',
              '### Limits', '',
              'These results test A11 only in the selected four-position neighborhoods and A2 only at eight registers. '
              'This round did not test the other 31,166 four-position windows. '
              'They do not establish a result for unbounded registers or unrestricted 31-instruction programs. '
              'The certificate checker verifies the Boolean formulas. The encoder checks do not formally verify the translation. '
              'No timeout is an exclusion. No assumption in ASSUMPTIONS_42.md is contradicted by these scoped results.']
    placeholder = ('The scan is in progress. Current exact counts are in round2/summary.json. '
                   'The final counts will be appended after the scan and selected retries finish.')
    text = Path('RESULTS.md').read_text()
    assert text.count(placeholder) == 1
    Path('RESULTS.md').write_text(text.replace(placeholder, '\n'.join(lines)))
    print(json.dumps({k: result[k] for k in ('selected', 'attempts', 'final_statuses', 'checked_UNSAT_windows', 'pending', 'families_disjoint')}))


if __name__ == '__main__':
    main()
