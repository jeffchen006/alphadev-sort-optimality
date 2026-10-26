"""Audit completed solver records and append their scoped result."""
from collections import Counter
from pathlib import Path
import hashlib
import itertools
import json
import os

HERE = Path(__file__).resolve().parent


def main():
    assert os.getpriority(os.PRIO_PROCESS, 0) == 19
    assert not (HERE/'active.json').exists(), 'Batch still has an active query'
    progress = json.loads((HERE/'progress.json').read_text())
    assert progress['all_jobs_finished'], 'Batch is still running'
    queue = json.loads((HERE/'queue.json').read_text())
    results = json.loads((HERE/'results.json').read_text())
    keys = lambda rows: {(x['seed'], tuple(x['slots'])) for x in rows}
    assert len(keys(queue)) == len(queue) == 797
    assert len(keys(results)) == len(results)
    assert keys(results) <= keys(queue)
    digest_ledger = []
    for row in results:
        log = Path(row['log'])
        events = []
        for line in log.read_text().splitlines():
            try:
                events.append(json.loads(line))
            except ValueError:
                pass
        terminal = next((x for x in reversed(events) if 'status' in x), None)
        assert terminal is not None and terminal == row['last']
        if row['status'] == 'UNSAT':
            assert row['code'] == 0 and terminal['status'] == 'UNSAT'
            solved = [x for x in events if x.get('step') == 'kissat_result'][-1]
            assert solved['solver_status'] == 'UNSAT' and solved['returncode'] == 20
            raw = Path(solved['raw_log'])
            assert 's UNSATISFIABLE' in raw.read_text().splitlines()
            digest_ledger.append(dict(seed=row['seed'], slots=row['slots'],
                  encoded_types=terminal['types'], cnf_sha256=solved['cnf_sha256'],
                  log=str(log), log_sha256=hashlib.sha256(log.read_bytes()).hexdigest(),
                  raw_log=str(raw), raw_sha256=hashlib.sha256(raw.read_bytes()).hexdigest()))
    old = HERE.parent/'round6'
    effective = {}
    for file in old.glob('*_slots_*.json'):
        for row in json.loads(file.read_text()):
            effective[(row['seed'], tuple(row['slots']))] = row['status']
    for row in json.loads((old/'focused_results.json').read_text()):
        if row['status'] == 'UNSAT':
            effective[(row['seed'], tuple(row['slots']))] = 'UNSAT'
    for row in results:
        effective[(row['seed'], tuple(row['slots']))] = row['status']
    assert len(effective) == 930
    pairset = set(itertools.combinations(range(31), 2))
    for seed in ('near9', 'near14'):
        assert {p for s, p in effective if s == seed} == pairset
    passes = []
    for line in (HERE/'judge_ledger.jsonl').read_text().splitlines():
        row = json.loads(line)
        if row['passed']:
            file, log = Path(row['file']), Path(row['log'])
            assert hashlib.sha256(file.read_bytes()).hexdigest() == row['sha256']
            assert log.read_text().startswith('PASS ')
            passes.append(row)
    for file in (HERE/'seeds').iterdir():
        assert file.read_bytes() == (old/'seeds'/file.name).read_bytes()
    source_hashes = json.loads((HERE/'source_integrity.json').read_text())
    for name, digest in source_hashes.items():
        assert hashlib.sha256(Path(name).read_bytes()).hexdigest() == digest, name
    summary = dict(planned=len(queue), completed=len(results),
         not_started=len(queue)-len(results),
         status_counts=dict(Counter(r['status'] for r in results)),
         by_seed={s:dict(Counter(r['status'] for r in results if r['seed'] == s))
                  for s in ('near9', 'near14')},
         combined_round6_round7={s:dict(Counter(v for (name, p), v in effective.items()
                                                      if name == s))
                                for s in ('near9', 'near14')},
         query_wall_seconds=sum(r['seconds'] for r in results),
         max_query_wall_seconds=max(r['seconds'] for r in results),
         max_observed_job_rss_kib=max(r['last'].get('stats', {}).get('peak_job_rss_kib', 0)
                                      for r in results),
         encoded_type_counts=dict(Counter(r['last'].get('types', 0) for r in results)),
         solver_calls=sum(r['solver_calls'] for r in results),
         queries_with_counterexample_refinement=sum(r['solver_calls'] > 1 for r in results),
         max_encoded_cases=max(r['last'].get('types', 0) for r in results),
         pass_files=passes, audited_unsat_logs=len(digest_ledger),
         checked_source_and_solver_hashes=len(source_hashes),
         all_jobs_finished=True, assumption_tags=['G1','G2','G3','A2','A11'])
    (HERE/'unsat_integrity.json').write_text(json.dumps(digest_ledger, indent=2)+'\n')
    (HERE/'final_summary.json').write_text(json.dumps(summary, indent=2)+'\n')
    lines = ['\n\n### Round-7 final result\n',
             f"The batch finished {len(results)} of 797 planned longer queries. Counts: `{summary['status_counts']}`. "
             f"Unstarted pairs: {summary['not_started']}. No limited or unstarted query counts as an exclusion.\n",
             '| Input | Longer queries completed | UNSAT | Other results |',
             '|---|---:|---:|---:|']
    for seed in ('near9', 'near14'):
        group = [r for r in results if r['seed'] == seed]
        negatives = sum(r['status'] == 'UNSAT' for r in group)
        lines.append(f'| {seed} | {len(group)} | {negatives} | {len(group)-negatives} |')
    lines += ['', 'Combined round-6 and round-7 pair counts: '
              f"`{summary['combined_round6_round7']}`. Each seed has 465 possible pairs. "
              'UNSAT excludes only the encoded finite repair relation. '
              'It does not exclude a repair with other free operands, extra registers, or more free positions.\n',
              f"The sum of query wall times is {summary['query_wall_seconds']:.2f} seconds. "
              f"The longest query took {summary['max_query_wall_seconds']:.2f} seconds. "
              f"The maximum observed combined parent and solver memory was {summary['max_observed_job_rss_kib']:,} KiB.\n",
              f"The batch made {summary['solver_calls']} solver calls. "
              f"Counterexample refinement occurred in {summary['queries_with_counterexample_refinement']} queries. "
              f"The largest encoded case set had {summary['max_encoded_cases']} weak orders.\n",
              'The final audit checked every reported UNSAT record against its Kissat exit code, '
              'UNSAT output, and saved log hashes. It checked retained PASS file hashes and seed integrity. '
              'The formula hash and encoded case count for each negative are in `round7/unsat_integrity.json`. '
              'Complete counts and PASS paths are in `round7/final_summary.json`.\n',
              'Assumption tags: [G1,G2,G3,A2,A11]. These are bounded local-repair results. '
              'They do not establish a global instruction lower bound. '
              'No assumption was contradicted. All round-7 jobs have finished.\n']
    if not any(r.get('strict_pass') for r in results):
        lines += ['No k<=31 program received a strict judge PASS in this round. '
                  'The target memory length of at most 41 remains open.\n']
    with (HERE.parent/'RESULTS.md').open('a') as stream:
        stream.write('\n'.join(lines))
    print(json.dumps(summary, indent=2))


if __name__ == '__main__':
    main()
