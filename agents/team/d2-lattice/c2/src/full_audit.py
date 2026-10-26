#!/usr/bin/env python3
"""Audit the completed full-column and sharper bound-two experiments."""
import collections
import hashlib
import json
from pathlib import Path
import resource

HERE = Path(__file__).resolve().parents[1]
ROUND = HERE/'round4full'


def digest(path):
    h = hashlib.sha256()
    with path.open('rb') as source:
        for block in iter(lambda: source.read(1024*1024), b''):
            h.update(block)
    return h.hexdigest()


def main():
    resource.setrlimit(resource.RLIMIT_AS, (2400*1024**2, 2400*1024**2))
    s = json.loads((ROUND/'summary.json').read_text())
    assert s.get('complete') and len(s['queries']) == 7, 'Full-column searches are incomplete'
    passes, artifacts = [], {}
    for q in s['queries']:
        cnf = Path(q['tag']+'.cnf')
        assert digest(cnf) == q['cnf_sha256']
        artifacts[str(cnf.relative_to(HERE))] = q['cnf_sha256']
        for key, source in [('encoder_sha256', HERE/'src/full_gap.py'),
                            ('base_encoder_sha256', HERE/'src/partial_sat.py'),
                            ('symmetry_helper_sha256', HERE/'src/partial_gap.py'),
                            ('flag_program_sha256', Path(q['flag_program']) if q['flag_program'] else None),
                            ('fixed_program_sha256', Path(q['fixed']) if q['fixed'] else None)]:
            if source is not None:
                assert digest(source) == q[key], ('Changed encoder or input', str(source))
        assert q['exhaustive_program_count'] == (0 if q['status'] == 'UNSATISFIABLE' else None)
        if q['status'] == 'SATISFIABLE':
            assert q['assignment_checked']
            v = json.loads(Path(q['tag']+'.validation.json').read_text())
            assert len(v['judges']) == 2
            for j in v['judges']:
                assert j['returncode'] == 0 and 'PASS ' in j['output'], j
                p = Path(j['file'])
                passes.append(dict(file=str(p.relative_to(HERE)), k=q['k'], model=j['model']))
                artifacts[str(p.relative_to(HERE))] = digest(p)
    for p in s['certificates']:
        cnf, proof = map(Path, p['command'][1:3])
        assert digest(cnf) == p['cnf_sha256']
        assert digest(proof) == p['proof_sha256']
    for p in [HERE/'src'/x for x in ('full_gap.py','full_run.py','full_two_run.py','full_audit.py')]+[ROUND/'METHOD.md']:
        artifacts[str(p.relative_to(HERE))] = digest(p)
    campaign = [json.loads(x) for x in (ROUND/'campaign.log').read_text().splitlines() if x]
    counts = collections.Counter(q['status'] for q in s['queries'])
    target_counts = collections.Counter(q['status'] for q in s['queries'] if q['k'] == 31)
    old = json.loads((HERE/'round4/final_report.json').read_text())
    combined = collections.Counter(old['query_statuses'])+counts
    result = dict(query_statuses=dict(counts), target_statuses=dict(target_counts),
                  combined_synthesis_statuses=dict(combined), strict_pass_files=passes,
                  certificates=s['certificates'], artifact_hashes=artifacts,
                  certificate_statuses=dict(collections.Counter(
                      'VERIFIED' if p['verified'] else p['checker_status'] for p in s['certificates'])),
                  recorded_child_cpu_seconds=sum(x['cpu_seconds'] for x in campaign),
                  maximum_recorded_child_rss_kib=max(x['maxrss_kib'] for x in campaign))
    (ROUND/'final_audit.json').write_text(json.dumps(result, indent=2)+'\n')
    lines = ['<!-- FULL_AUDIT_BEGIN -->', '### Full-column extension completed [A4, A15]', '',
             'The sharper reduction is constructive: q columns with undefined entries give',
             'at most max(0,q-1) full non-lattice written versions, when all original full',
             'columns are lattice and comparisons read defined values. It preserves core',
             'length, comparison count, comparison operand values, and required outputs.',
             'The proof and its limits are in `round4full/METHOD.md`.', '',
             '| query | bound | variables | clauses | solver CPU seconds | result | program count |',
             '|---|---:|---:|---:|---:|---|---:|']
    for q in s['queries']:
        count = q['exhaustive_program_count']
        lines.append(f"| {Path(q['tag']).name} | {q['bound']} | {q['variables']} | {q['clauses']} | "
                     f"{q['solver_cpu_seconds']:.3f} | {q['status']} | {count if count is not None else 'unknown'} |")
    lines += ['', 'Extension decisions: '+', '.join(f'{v} {k}' for k,v in sorted(counts.items()))+'.',
              'Combined new synthesis decisions in this round: '+
              ', '.join(f'{v} {k}' for k,v in sorted(combined.items()))+'.',
              'The separate one-hour sort4 retry remains UNKNOWN; its verified upper bound is k=20.', '',
              'Extension certificate checks: '+', '.join(f'{v} {k}' for k,v in
                  sorted(result['certificate_statuses'].items()))+'.', '',
              'The strict PASS paths are listed above. Every new sorting candidate was checked',
              'by the reference judge in both models. Source, formula, and certificate hashes',
              'were rechecked. The audit is `round4full/final_audit.json`.']
    found = [p for p in passes if p['k'] <= 31]
    if not found:
        lines += ['No sort5 k<=31 candidate passed. The general A15 claim remains open.',
                  'No assumption is marked CHALLENGED by this round.']
    lines += ['The original pending sort5 certificate was accepted in the longer retry.',
              'Four new fixed-block certificate checks remain incomplete at their limits.',
              'Their solver decisions remain UNSAT; the four checks did not report rejection.',
              f"Extension recorded child CPU use: {result['recorded_child_cpu_seconds']:.3f} seconds.",
              f"Extension maximum recorded child resident memory: {result['maximum_recorded_child_rss_kib']:,} KiB.",
              'All CPU jobs ran serially at nice level 19. All queued solver and certificate-checker processes have exited.',
              '<!-- FULL_AUDIT_END -->']
    path = HERE/'RESULTS.md'
    text = path.read_text()
    begin, end = '<!-- FULL_AUDIT_BEGIN -->', '<!-- FULL_AUDIT_END -->'
    if begin in text:
        a, b = text.index(begin), text.index(end)+len(end)
        text = text[:a]+'\n'.join(lines)+text[b:]
    else:
        text += '\n'+'\n'.join(lines)+'\n'
    path.write_text(text)
    print(json.dumps({k:v for k,v in result.items() if k not in ('artifact_hashes','certificates')},indent=2))


if __name__ == '__main__':
    main()
