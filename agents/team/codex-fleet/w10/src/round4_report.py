#!/usr/bin/env python3
"""Audit and append the completed round-4 records. Run after round4_run exits."""
import collections
import hashlib
import json
from pathlib import Path
import resource

HERE = Path(__file__).resolve().parents[1]
ROUND = HERE/'round4'
PROJECT = HERE.parents[3]


def digest(path):
    h = hashlib.sha256()
    with path.open('rb') as source:
        for block in iter(lambda: source.read(1024*1024), b''):
            h.update(block)
    return h.hexdigest()


def main():
    resource.setrlimit(resource.RLIMIT_AS, (2400*1024**2, 2400*1024**2))
    s = json.loads((ROUND/'summary.json').read_text())
    queries = s['queries']
    targets = [q for q in queries if q['k'] == 31]
    assert len(queries) == 18 and len(targets) == 12, 'Round 4 queries are incomplete'
    old = [p for p in s['certificates']
           if Path(p['log']).name.startswith('n5_k31_partial_flags_blocks')]
    assert old, 'The requested longer certificate retry is incomplete'
    if not old[0]['verified']:
        assert len(old) == 2, 'The equivalent-CNF fallback check is incomplete'
    new_proofs = [p for p in s['certificates'] if p not in old]
    all_passes = []
    artifacts = {}
    sort4_cnf = Path(s['sort4']['command'][-1])
    if not sort4_cnf.is_absolute():
        sort4_cnf = HERE/sort4_cnf
    assert digest(sort4_cnf) == s['sort4']['cnf_sha256'], 'Changed sort4 CNF'
    artifacts[str(sort4_cnf.relative_to(HERE))] = dict(bytes=sort4_cnf.stat().st_size,
                                                      sha256=s['sort4']['cnf_sha256'])
    for q in queries:
        tag = Path(q['tag'])
        cnf = Path(str(tag)+'.cnf')
        assert digest(cnf) == q['cnf_sha256'], ('Changed CNF', str(cnf))
        for key, source in [('encoder_sha256', HERE/'src/partial_gap.py'),
                            ('base_encoder_sha256', HERE/'src/partial_sat.py'),
                            ('flag_program_sha256', Path(q['flag_program']) if q['flag_program'] else None),
                            ('fixed_program_sha256', Path(q['fixed']) if q['fixed'] else None)]:
            if source is not None:
                assert digest(source) == q[key], ('Changed source', str(source))
        artifacts[str(cnf.relative_to(HERE))] = dict(bytes=cnf.stat().st_size,
                                                     sha256=q['cnf_sha256'])
        assert q['exhaustive_program_count'] == (0 if q['status'] == 'UNSATISFIABLE' else None)
        if q['status'] == 'SATISFIABLE':
            assert q['assignment_checked']
            v = json.loads(Path(str(tag)+'.validation.json').read_text())
            assert len(v['judges']) == 2
            for j in v['judges']:
                assert j['returncode'] == 0 and 'PASS ' in j['output'], j
                p = Path(j['file'])
                all_passes.append(str(p.relative_to(HERE)))
                artifacts[str(p.relative_to(HERE))] = dict(bytes=p.stat().st_size,
                                                           sha256=digest(p))
    for p in s['certificates']:
        # The checker command records its exact CNF and proof as arguments 1/2.
        cnf, proof = map(Path, p['command'][1:3])
        assert digest(cnf) == p['cnf_sha256'], ('Changed checked CNF', str(cnf))
        assert digest(proof) == p['proof_sha256'], ('Changed certificate', str(proof))
    campaign = [json.loads(x) for x in (ROUND/'campaign.log').read_text().splitlines() if x]
    source_paths = [HERE/'src'/x for x in ('partial_sat.py', 'partial_gap.py',
                    'partial_validate.py', 'partial_sym.py', 'round4_run.py', 'round4_report.py')]
    source_paths += [ROUND/'METHOD.md', ROUND/'ONE_COLUMN_LEMMA.md']
    for p in source_paths:
        artifacts[str(p.relative_to(HERE))] = dict(bytes=p.stat().st_size, sha256=digest(p))
    for p in (PROJECT/'shared/judge.py', PROJECT/'bin/kissat', PROJECT/'bin/drat-trim'):
        artifacts[str(p)] = dict(bytes=p.stat().st_size, sha256=digest(p),
                                 resolved_path=str(p.resolve()))
    result = dict(query_statuses=dict(collections.Counter(q['status'] for q in queries)),
                  target_statuses=dict(collections.Counter(q['status'] for q in targets)),
                  sort4_status=s['sort4']['status'],
                  new_certificate_counts=dict(collections.Counter(
                      'VERIFIED' if p['verified'] else p['checker_status'] for p in new_proofs)),
                  old_certificate_results=old, strict_pass_files=all_passes,
                  recorded_child_cpu_seconds=sum(r['cpu_seconds'] for r in campaign)+
                      sum(s['sort4']['children_usage'][:2]),
                  maximum_recorded_child_rss_kib=max(r['maxrss_kib'] for r in campaign),
                  artifact_hashes=artifacts)
    found = [q for q in targets if q['status'] == 'SATISFIABLE']
    (ROUND/'final_report.json').write_text(json.dumps(result, indent=2)+'\n')
    lines = ['<!-- ROUND4_FINAL_BEGIN -->', '### Round 4 completed run record [A4, A15]', '',
             f"The {len(queries)} new synthesis queries returned " +
             ', '.join(f'{v} {k}' for k, v in sorted(result['query_statuses'].items()))+'.',
             'The separate one-hour sort4 retry returned '+s['sort4']['status']+'.',
             'The sort4 upper bound remains k=20. Its free-outcome k=19 class is unresolved.', '',
             '| sort5 k=31 query | c | mode | blocks | solver result | program count |',
             '|---|---:|---|---|---|---:|']
    for q in targets:
        count = q['exhaustive_program_count']
        lines.append(f"| {Path(q['tag']).name} | {q['c']} | {q['mode']} | "
                     f"{q['blocks'] or 'free'} | {q['status']} | "
                     f"{count if count is not None else 'unknown'} |")
    lines += ['', 'The zero counts have the exact scopes stated above and in `round4/METHOD.md`.',
              'An UNKNOWN query has an unknown correct-program count.', '',
              'New certificate checks: '+', '.join(f'{v} {k}' for k, v in
                                                  sorted(result['new_certificate_counts'].items()))+'.',
              'Old sort5 certificate retry records:', '']
    lines += [f"- `{Path(p['log']).name}`: {p['checker_status']}; "
              f"verified={str(p['verified']).lower()}; {p['elapsed_seconds']:.3f} seconds."
              for p in old]
    lines += ['', f"There are {len(all_passes)} new strict judge PASS files. "
              'Their paths are listed in the live result table.',
              ('A sort5 k<=31 candidate passed both strict judge models.' if found else
               'No sort5 k<=31 candidate passed the strict judge in this round.'),
              'The restricted rewrite argument is in `round4/ONE_COLUMN_LEMMA.md`.',
              ('The new strict result requires A15 review.' if found else
               'The general A15 claim remains open. No assumption is marked CHALLENGED.'), '',
              f"Recorded child CPU use, including sort4 and checks: {result['recorded_child_cpu_seconds']:.3f} seconds.",
              f"Maximum recorded child resident memory: {result['maximum_recorded_child_rss_kib']:,} KiB.",
              'All CPU jobs ran serially at nice level 19. All hashes were rechecked.',
              'The audit and source hashes are in `round4/final_report.json`.',
              '<!-- ROUND4_FINAL_END -->']
    path = HERE/'RESULTS.md'
    text = path.read_text()
    begin, end = '<!-- ROUND4_FINAL_BEGIN -->', '<!-- ROUND4_FINAL_END -->'
    if begin in text:
        a, b = text.index(begin), text.index(end)+len(end)
        text = text[:a]+'\n'.join(lines)+text[b:]
    else:
        text += '\n'+'\n'.join(lines)+'\n'
    path.write_text(text)
    print(json.dumps({k: v for k, v in result.items() if k not in ('artifact_hashes', 'old_certificate_results')}, indent=2))


if __name__ == '__main__':
    main()
