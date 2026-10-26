#!/usr/bin/env python3
"""Extend only the 67 unresolved round-2 routing cases, one process at a time."""
import json, os, resource, subprocess, sys, time
from pathlib import Path
from candidate import check

ROOT = Path(__file__).resolve().parents[2]
resource.setrlimit(resource.RLIMIT_AS, (2900 * 1024**2, 2900 * 1024**2))
os.sched_setaffinity(0, {min(os.sched_getaffinity(0))})
calls = int(sys.argv[1]) if len(sys.argv) > 1 else 100_000_000
seconds = int(sys.argv[2]) if len(sys.argv) > 2 else 180
done = set()
index = ROOT / 'round3/logs/routes.jsonl'
if index.exists():
    for line in index.read_text().splitlines():
        row = json.loads(line)
        if 'RESULT NONE ' in row.get('result', '') or 'RESULT FOUND ' in row.get('result', ''):
            done.add(row['file'])
jobs = (ROOT / 'round2/logs/unresolved_routes.txt').read_text().splitlines()
start = time.monotonic()
with index.open('a', buffering=1) as summary:
    for rel in jobs:
        if rel in done:
            continue
        path = ROOT / rel
        log = ROOT / 'round3/logs' / (path.stem + '.route')
        begin = time.monotonic()
        with log.open('w') as stream:
            q = subprocess.run(['nice', '-n', '19', 'timeout', str(seconds),
                                str(ROOT / 'src/dagx'), str(path), '31', '1', str(calls)],
                               stdout=stream, stderr=subprocess.STDOUT)
        rows = log.read_text().splitlines()
        result = rows[-1] if rows else 'EMPTY'
        row = dict(file=rel, rc=q.returncode, result=result, calls_cap=calls,
                   seconds_cap=seconds, seconds=round(time.monotonic()-begin, 3),
                   elapsed=round(time.monotonic()-start, 3))
        summary.write(json.dumps(row) + '\n')
        print(json.dumps(row), flush=True)
        if 'RESULT FOUND ' in result:
            asm = [s for s in rows if s.startswith(('mov ', 'cmp ', 'cmovl ', 'cmovle ',
                                                  'cmovg ', 'cmovge ', 'out '))]
            target = ROOT / 'round3/programs' / (path.stem + '.s')
            target.write_text('# n=5 R=100 iset=I1 model=out source=w3_round3_routing\n' +
                              '\n'.join(asm) + '\n')
            check(target)
