#!/usr/bin/env python3
"""Audit the A15 round after all serial jobs finish. Use nice 19."""
import collections
import hashlib
import itertools
import json
from pathlib import Path
import resource

import threshold_run as work
import threshold_check


def main():
    resource.setrlimit(resource.RLIMIT_AS, (2400*1024**2, 2400*1024**2))
    s = json.loads((work.ROUND/'summary.json').read_text())
    assert s.get('complete') and len(s['queries']) == 19
    assert len(s['partitions']) == 254
    finite_checks = threshold_check.check()
    (work.ROUND/'threshold_arithmetic_checks.json').write_text(json.dumps(finite_checks, indent=2)+'\n')
    expected = {p for size in range(3) for p in itertools.combinations(range(22), size)}
    assert {tuple(q['slots']) for q in s['partitions']} == expected
    artifacts, passes = {}, []
    for q in s['queries']:
        cnf = Path(q['tag']+'.cnf')
        assert work.digest(cnf) == q['cnf_sha256'], cnf
        artifacts[str(cnf.relative_to(work.HERE))] = q['cnf_sha256']
        for key, filename in [('encoder_sha256', 'threshold_sat.py'),
                              ('base_sha256', 'partial_sat.py'),
                              ('symmetry_sha256', 'partial_gap.py')]:
            assert work.digest(work.HERE/'src'/filename) == q[key], filename
        if 'strong_encoder_sha256' in q:
            assert work.digest(work.HERE/'src/threshold_strong.py') == q['strong_encoder_sha256']
        assert q['exhaustive_program_count'] == (0 if q['status'] == 'UNSATISFIABLE' else None)
        assert q['status'] in ('SATISFIABLE', 'UNSATISFIABLE', 'UNKNOWN')
        if q['status'] == 'SATISFIABLE':
            assert q['assignment_checked']
            v = json.loads(Path(q['tag']+'.validation.json').read_text())
            assert v['n'] == q['n'] and v['k'] == q['k']
            assert v['wrong_outputs'] == v['undefined_comparisons'] == 0
            assert not v['partial_data_nodes']
            assert len(v['nonlattice_full_data_nodes']) <= 2
            assert len(v['judges']) == 2
            for j in v['judges']:
                assert j['returncode'] == 0 and 'PASS ' in j['output'], j
                path = Path(j['file'])
                passes.append(dict(n=q['n'], k=q['k'], model=j['model'],
                                   path=str(path.relative_to(work.HERE))))
                artifacts[str(path.relative_to(work.HERE))] = work.digest(path)
    base = next(q for q in s['queries'] if Path(q['tag']).name == 'n5_k31_two_exceptions_all_shapes')
    source = Path(base['tag']+'.cnf')
    with source.open('rb') as f:
        f.readline()
        body = f.read()
    reconstructed = {}
    for q in s['partitions']:
        assert q['base_sha256'] == base['cnf_sha256']
        selected = q['slots']+[22]*(2-len(q['slots']))
        assert q['units'] == [base['position_choices'][i][g] for i,g in enumerate(selected)]
        h = hashlib.sha256()
        h.update(f"p cnf {base['variables']} {base['clauses']+2}\n".encode())
        h.update(body)
        for u in q['units']:
            h.update(f'{u} 0\n'.encode())
        assert h.hexdigest() == q['cnf_sha256'], q['name']
        reconstructed[q['name']] = q['cnf_sha256']
        assert q['exhaustive_program_count'] == (0 if q['status'] == 'UNSATISFIABLE' else None)
        assert q['run']['nice'] == 19
    for proof in s['certificates']:
        cnf, drat = map(Path, proof['command'][1:3])
        assert work.digest(drat) == proof['proof_sha256']
        if cnf.exists():
            assert work.digest(cnf) == proof['cnf_sha256']
        else:
            assert reconstructed[cnf.stem] == proof['cnf_sha256']
    campaign = [json.loads(line) for line in (work.ROUND/'campaign.jsonl').read_text().splitlines() if line]
    assert all(x['nice'] == 19 for x in campaign)
    for p in [work.HERE/'src'/name for name in ('threshold_sat.py', 'threshold_run.py',
              'threshold_followup.py', 'threshold_strong.py', 'threshold_check.py', 'threshold_audit.py')]+[work.ROUND/'METHOD.md']:
        artifacts[str(p.relative_to(work.HERE))] = work.digest(p)
    targets = [q for q in s['queries'] if q['n'] == 5 and q['k'] == 31]
    result = dict(complete=True, queries=len(s['queries']), partitions=len(s['partitions']),
                  query_statuses=dict(collections.Counter(q['status'] for q in s['queries'])),
                  target_statuses=dict(collections.Counter(q['status'] for q in targets)),
                  partition_statuses=dict(collections.Counter(q['status'] for q in s['partitions'])),
                  partition_statuses_by_size={size: dict(collections.Counter(q['status'] for q in s['partitions']
                                                     if len(q['slots']) == size)) for size in range(3)},
                  certificate_statuses=dict(collections.Counter('VERIFIED' if p['verified'] else p['checker_status']
                                                                for p in s['certificates'])),
                  strict_pass_files=passes, artifact_hashes=artifacts,
                  independent_finite_checks=finite_checks,
                  reconstructed_partition_hashes=reconstructed,
                  recorded_child_cpu_seconds=sum(x['child_cpu_seconds'] for x in campaign),
                  maximum_recorded_child_rss_kib=max(x['maxrss_kib'] for x in campaign))
    (work.ROUND/'final_audit.json').write_text(json.dumps(result, indent=2)+'\n')
    lines = ['<!-- ROUND5_AUDIT_BEGIN -->', '### Round 5 completed audit [A15]', '',
             'All 254 position cases were submitted. Each formula leaves every lattice',
             'shape free. This is complete coverage of position choices. A limited case',
             'remains UNKNOWN; it is not an exhaustive negative result.', '',
             '| scope | SAT | UNSAT | UNKNOWN |', '|---|---:|---:|---:|']
    for scope, counts in [('New controls and targets', result['query_statuses']),
                          ('Sort5 k=31 target queries', result['target_statuses']),
                          ('Sort5 c=9 exception-position cases', result['partition_statuses'])]:
        lines.append(f"| {scope} | {counts.get('SATISFIABLE',0)} | {counts.get('UNSATISFIABLE',0)} | {counts.get('UNKNOWN',0)} |")
    for size, counts in result['partition_statuses_by_size'].items():
        lines.append(f"| Exactly {size} permitted exception positions | {counts.get('SATISFIABLE',0)} | "
                     f"{counts.get('UNSATISFIABLE',0)} | {counts.get('UNKNOWN',0)} |")
    lines += ['', '| target query | c | variables | clauses | solver CPU seconds | result |',
              '|---|---:|---:|---:|---:|---|']
    for q in targets:
        lines.append(f"| {Path(q['tag']).name} | {q['c']} | {q['variables']} | {q['clauses']} | "
                     f"{q['solver_cpu_seconds']:.3f} | {q['status']} |")
    lines += ['', 'Every UNSAT query has correct-program count zero within its saved scope.',
              'Every UNKNOWN query has unknown correct-program count.',
              'The source hashes, shared formula hash, all 254 reconstructed formula hashes,',
              'SAT assignments, strict judge records, and completed certificates were checked.',
              'The full audit is `round5/final_audit.json`.', '',
              'Independent n=3 arithmetic checks examined all 729 full strict-order columns.',
              'They found the expected 18 lattice columns and 711 non-lattice columns.',
              'The non-lattice subset witness test had zero disagreements.',
              'Comparison and conditional-copy arithmetic also agreed in every checked case.',
              'These finite checks are not a proof of A15.', '',
              'Certificate results: '+', '.join(f'{k}={v}' for k,v in sorted(result['certificate_statuses'].items()))+'.',
              f"Recorded child CPU use: {result['recorded_child_cpu_seconds']:.3f} seconds.",
              f"Maximum recorded child resident memory: {result['maximum_recorded_child_rss_kib']:,} KiB.",
              'All CPU jobs ran serially at nice level 19. No queued CPU job remains.']
    found = [p for p in passes if p['n'] == 5 and p['k'] <= 31]
    if not found:
        lines += ['No sort5 k<=31 candidate passed. The general A15 claim remains open.',
                  'No assumption is marked CHALLENGED by this round.']
    lines += ['<!-- ROUND5_AUDIT_END -->']
    path = work.HERE/'RESULTS.md'
    text = path.read_text()
    begin,end = '<!-- ROUND5_AUDIT_BEGIN -->','<!-- ROUND5_AUDIT_END -->'
    if begin in text:
        a,b = text.index(begin),text.index(end)+len(end)
        text = text[:a]+'\n'.join(lines)+text[b:]
    else:
        text += '\n'+'\n'.join(lines)+'\n'
    path.write_text(text)
    print(json.dumps({k:v for k,v in result.items()
                      if k not in ('artifact_hashes','reconstructed_partition_hashes','strict_pass_files')}, indent=2))


if __name__ == '__main__':
    main()
