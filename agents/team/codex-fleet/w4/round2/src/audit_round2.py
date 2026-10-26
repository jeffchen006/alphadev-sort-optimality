#!/usr/bin/env python3
"""Collect completed search scopes and strict-judge artifacts without rerunning searches."""
from collections import Counter
from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path
import re

BASE = Path(__file__).resolve().parents[1]
ROOT = BASE.parent


def program(path):
    instructions = []
    for line in path.read_text().splitlines():
        line = line.split('#')[0].strip()
        if line and not line.startswith('out '):
            instructions.append(line)
    return instructions


def records(path):
    result = []
    for line in path.read_text().splitlines():
        try:
            result.append(json.loads(line))
        except ValueError:
            pass
    return result


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    queries = []
    for batch in ['crossing', 'templates', 'binary', 'tailfree', 'tailone', 'dense']:
        data = json.loads((BASE/'logs'/f'{batch}_summary.json').read_text())
        for item in data:
            solves = [r for r in item['records'] if r.get('phase') == 'solve']
            assert solves and item['returncode'] == 0, item['tag']
            task = item['task']
            length = len(program(BASE/'seeds'/task['seed'])) - task.get('delta', 1)
            assert length == 31
            queries.append(dict(tag=item['tag'], task=task, k=length,
                                final=solves[-1], solves=solves,
                                resources=next((r for r in item['records'] if r.get('phase') == 'resources'), None),
                                judge=item.get('judge')))
    for name, seed, a, b, random_seed in [
        ('free_palette_8_32', 'palette_c8_k32.s', 8, 32, 4101),
        ('free_c8c_9_32', 'c8c_len32_c29288.s', 9, 32, 4102),
    ]:
        rr = records(BASE/'logs'/f'{name}.log')
        solves = [r for r in rr if r.get('phase') == 'solve']
        assert solves
        queries.append(dict(tag=name, k=31, final=solves[-1], solves=solves,
                            resources=None,
                            task=dict(seed=seed, a=a, b=b, delta=1, mode='free',
                                      comparisons=6, cases=8, seconds=600,
                                      random_seed=random_seed, extra=0)))
    checked = []
    for log in sorted((BASE/'logs').glob('*.judge')):
        text = log.read_text()
        match = re.search(r'^(PASS|FAIL) (.+?) \[relaxed\+strict\].*? L=(\d+) ', text, re.M)
        assert match, log
        status, name, count = match.groups()
        path = Path(name)
        if not path.is_absolute():
            path = ROOT/path
        relative = path.relative_to(ROOT).as_posix()
        assert path.is_file(), path
        assert len(program(path)) == int(count), path
        checked.append(dict(path=relative, status=status, length=int(count),
                            sha256=digest(path), log=log.relative_to(ROOT).as_posix(),
                            output=text))
    checked_paths = {r['path'] for r in checked}
    for candidate in (BASE/'candidates').glob('*.s'):
        assert candidate.relative_to(ROOT).as_posix() in checked_paths, candidate
    outcomes = Counter(q['final']['status'] for q in queries)
    measured = [q['resources'] for q in queries if q['resources']]
    result = dict(
        audited_utc=datetime.now(timezone.utc).isoformat(),
        target_queries=len(queries), final_status_counts=dict(outcomes),
        sat_conflicts=sum(q['final']['stats']['conflicts'] for q in queries),
        recorded_cpu_seconds=round(sum(r['cpu_seconds'] for r in measured), 3),
        cpu_measurement_queries=len(measured),
        maximum_recorded_peak_rss_kib=max(r['peak_rss_kib'] for r in measured),
        verified_target=any(r['status'] == 'PASS' and r['length'] <= 31 for r in checked),
        judge_status_counts=dict(Counter(r['status'] for r in checked)),
        source_hashes={p.relative_to(ROOT).as_posix():digest(p) for p in (BASE/'src').glob('*.py')},
        seed_hashes={p.relative_to(ROOT).as_posix():digest(p) for p in (BASE/'seeds').glob('*.s')},
        checked=checked, queries=queries)
    (BASE/'logs/final_audit.json').write_text(json.dumps(result, indent=2)+'\n')
    print(json.dumps({key:value for key,value in result.items()
                      if key not in ['queries','checked','source_hashes','seed_hashes']}, indent=2))


if __name__ == '__main__':
    main()
