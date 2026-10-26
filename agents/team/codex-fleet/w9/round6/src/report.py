"""Report the continuation of the 102 unrecorded class representatives."""
from collections import Counter
from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path

HERE = Path(__file__).resolve().parents[1]
BASE = HERE.parent
OLD = BASE / 'round5'
MARK = '\n## Round 6 — remaining 102 structure representatives\n'


def atomic(path, value):
    tmp = path.with_suffix(path.suffix + '.round6.tmp')
    tmp.write_text(value)
    tmp.replace(path)


def update():
    start = json.loads((HERE / 'artifacts/start.json').read_text())
    queue_path = OLD / 'artifacts/queue.json'
    assert hashlib.sha256(queue_path.read_bytes()).hexdigest() == start['queue_sha256']
    ledger = (OLD / 'artifacts/class_results.jsonl').read_bytes()
    lines = ledger.splitlines(keepends=True)
    initial = b''.join(lines[:start['starting_recorded']])
    assert hashlib.sha256(initial).hexdigest() == start['starting_ledger_sha256']
    rows = [json.loads(line) for line in lines if line.strip()]
    assert len(rows) == len({row['class_id'] for row in rows})
    wanted = set(start['remaining_class_ids'])
    new = [row for row in rows if row['class_id'] in wanted]
    for row in new:
        assert row['limit_seconds'] == 900 and row['origin_cuts']
    done = {row['class_id'] for row in new}
    summary_path = OLD / 'artifacts/summary.json'
    current = json.loads(summary_path.read_text()).get('current') if summary_path.exists() else None
    summary = {
        'updated_utc': datetime.now(timezone.utc).isoformat(),
        'started_utc': start['started_utc'],
        'requested': len(wanted), 'recorded': len(new),
        'statuses': dict(Counter(row['status'] for row in new)),
        'remaining_class_ids': [i for i in start['remaining_class_ids'] if i not in done],
        'all_recorded': len(rows),
        'all_statuses': dict(Counter(row['status'] for row in rows)),
        'current': current,
        'complete': wanted == done,
        'parent_cpu_seconds': sum(row['cpu'] for row in new),
        'child_cpu_seconds': sum(row['stats']['child_cpu_seconds'] for row in new),
        'query_wall_seconds': sum(row['wall'] for row in new),
        'peak_job_rss_kib': max((row['stats']['peak_job_rss_kib'] for row in new), default=0),
        'candidate_models': sum(len(row.get('models', [])) for row in new),
        'strict_pass_files': [],
        'assumptions': start['assumptions'],
        'per_query_wall_limit_seconds': 900,
    }
    for row in new:
        if not row.get('strict_pass'):
            continue
        assert row.get('memory_strict_pass')
        for path_key, log, model in [
            ('path', row['models'][-1]['judge_log'], 'out'),
            ('memory_path', row['memory_strict_log'], 'mem'),
        ]:
            path = Path(row[path_key])
            output = Path(log).read_text()
            assert 'PASS ' in output and '[relaxed+strict]' in output and f'model={model}' in output
            summary['strict_pass_files'].append({
                'path': str(path), 'model': model, 'k': row['k'],
                'judge_log': log, 'judge_output': output.strip(),
                'sha256': hashlib.sha256(path.read_bytes()).hexdigest(),
            })
    atomic(HERE / 'artifacts/summary.json', json.dumps(summary, indent=2) + '\n')
    text = MARK + (
        '\nRead all prior results before this continuation. The saved ledger began at 204/306 representatives: '
        '200 UNSAT and four UNKNOWN. The saved queue identified 102 unrecorded representatives. '
        'All 102 passed the earlier necessary information filter. No recorded representative is rerun. '
        'The interrupted class_121_q0015 query had no result record and receives its full budget.\n\n'
        'Assumptions tested: A2 (finite register bound), A4 (fixed comparison-flag histories), '
        'A6 (comparison order), and A11 (fixed-prefix repair scope). The representatives retain their saved '
        'prefixes, register bounds, comparison positions, direction options, and seed cases. '
        'The encoder and Kissat wrapper are unchanged. Only continuation reporting was added.\n\n'
        'Each query gets a 900-second wall budget shared across construction, Kissat calls, and refinements. '
        'One CPU job runs at nice level 19. The address-space limit is 2,800 MiB. '
        'The wrapper also enforces a combined resident-memory limit of 2,800,000 KiB. '
        'All writes remain in w9. No agents were started.\n\n'
        f"Completed in this continuation: {len(new)}/102; {summary['statuses']}. "
        f"Unrecorded: {len(wanted - done)}. Total recorded: {len(rows)}/306; {summary['all_statuses']}.\n\n"
        f"Recorded parent CPU seconds: {summary['parent_cpu_seconds']:.3f}. "
        f"Child CPU seconds: {summary['child_cpu_seconds']:.3f}. "
        f"Summed query wall seconds: {summary['query_wall_seconds']:.3f}. "
        f"Peak recorded combined resident memory: {summary['peak_job_rss_kib']} KiB.\n\n"
        f"Decoded candidate models in this continuation: {summary['candidate_models']}. "
    )
    if summary['strict_pass_files']:
        text += 'Every new strict PASS file follows.\n\n'
        text += '| PASS file | Model | Core length | Judge output |\n|---|---|---:|---|\n'
        for row in summary['strict_pass_files']:
            path = Path(row['path'])
            log = Path(row['judge_log'])
            text += f"| [{path.name}]({path.relative_to(BASE)}) | {row['model']} | {row['k']} | [PASS]({log.relative_to(BASE)}) |\n"
    else:
        text += 'No new strict PASS is recorded.\n'
    text += (
        '\nA time limit remains UNKNOWN. An unrecorded representative remains UNRUN. '
        'A representative UNSAT result does not exclude the other members of its descriptive class. '
        'No independently checked UNSAT certificate was produced. No global lower bound follows.\n\n'
        'Files: [continuation summary](round6/artifacts/summary.json), '
        '[start snapshot](round6/artifacts/start.json), '
        '[per-class status](round5/CLASS_STATUS.md), '
        '[query ledger](round5/artifacts/class_results.jsonl), and '
        '[current activity](round5/LIVE.md). '
        'Resume with `nice -n 19 bash round6/run_remaining.sh`.\n'
    )
    if not summary['complete']:
        text += f"\nContinuation incomplete. Current query: {current or 'none'}.\n"
    else:
        text += '\nAll 102 requested representatives now have a result record.\n'
    target = BASE / 'RESULTS.md'
    atomic(target, target.read_text().split(MARK)[0] + text)
    return summary


if __name__ == '__main__':
    print(json.dumps(update()), flush=True)
