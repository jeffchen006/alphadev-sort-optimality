#!/usr/bin/env python3
"""Check saved routing records without repeating any solver search."""
import collections
import hashlib
import json
from pathlib import Path
import re
import time

ROOT = Path(__file__).resolve().parent
ASSIGNED = ROOT.parents[1] / 'd1-skeleton/out/w8r4u_half2_for_w14.txt'


def digest(data):
    return hashlib.sha256(data).hexdigest()


def main():
    manifest = json.loads((ROOT / 'manifest.json').read_text())
    paths = (ROOT / 'assigned.txt').read_text().splitlines()
    assert (ROOT / 'assigned.txt').read_bytes() == ASSIGNED.read_bytes()
    assert len(paths) == len(manifest) == 10696
    assert len({r['sha256'] for r in manifest}) == len(manifest)
    by_hash = {}
    for index, row in enumerate(manifest):
        assert row['index'] == index and row['source'] == paths[index]
        data = (ROOT / row['local']).read_bytes()
        assert digest(data) == row['file_sha256']
        assert data == Path(row['source']).read_bytes()
        lines = [x.strip() for x in data.decode().splitlines()
                 if x.strip() and not x.startswith('#')]
        assert digest(('\n'.join(lines) + '\n').encode()) == row['sha256']
        assert len(lines) == row['comparisons']
        by_hash[row['sha256']] = row

    # The active runner only appends complete JSON lines.
    raw = (ROOT / 'runs.jsonl').read_bytes()
    if raw and not raw.endswith(b'\n'):
        raw = raw[:raw.rfind(b'\n') + 1]
    records = [json.loads(line) for line in raw.splitlines()]
    latest = {}
    result_re = re.compile(r'^RESULT (NONE|FOUND|LIMIT) K=31 calls=(\d+)', re.M)
    for row in records:
        original = by_hash[row['sha256']]
        assert all(row[k] == original[k] for k in ('index', 'local', 'source', 'comparisons'))
        prior = latest.get(row['sha256'])
        assert row['attempt'] == (prior['attempt'] + 1 if prior else 1)
        assert not prior or prior['status'] == 'LIMIT'
        log = (ROOT / row['log']).read_text()
        result = result_re.search(log)
        if row['status'] == 'NONE':
            assert row['returncode'] == 0 and not row['timed_out']
            assert result and result[1] == 'NONE'
            assert int(result[2]) == row['calls']
            assert 'node limit hit' not in log
        elif row['status'] == 'FOUND':
            assert result and result[1] == 'FOUND'
            checks = row['judge_checks']
            assert {c['model'] for c in checks} == {'mem', 'out'}
            assert all(c['pass_strict'] for c in checks)
            assert all('PASS' in Path(c['log']).read_text() for c in checks)
        else:
            assert row['status'] == 'LIMIT'
        latest[row['sha256']] = row

    report = dict(
        updated=time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime()),
        assigned=len(manifest), attempted=len(latest), attempts=len(records),
        counts=dict(collections.Counter(r['status'] for r in latest.values())),
        unattempted=len(manifest)-len(latest),
        comparison_counts=dict(collections.Counter(r['comparisons'] for r in manifest)),
        completed_attempt_wall_seconds=sum(r['elapsed'] for r in records),
        copied_inputs_match_sources=True, assigned_list_match=True,
        records_and_logs_checked=True,
        source_sha256=digest((ROOT / 'dagx.cpp').read_bytes()),
        executable_sha256=digest((ROOT / 'dagx').read_bytes()),
        history_snapshot_sha256=digest(raw))
    (ROOT / 'audit.json').write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    main()
