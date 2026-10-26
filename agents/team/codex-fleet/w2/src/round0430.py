#!/usr/bin/env python3
"""Retry the 47 unresolved cases at 500M nodes, retaining exhausted results."""
import csv
import hashlib
import json
import os
import re
import resource
import subprocess
import time
from collections import Counter
from pathlib import Path

resource.setrlimit(resource.RLIMIT_AS, (2800000000, 2800000000))
os.nice(max(0, 19 - os.getpriority(os.PRIO_PROCESS, 0)))
base = Path('logs/round0430')
base.mkdir(exist_ok=True)
rows = list(csv.DictReader(Path('logs/recompute9_priority/unknown_priority.tsv').open(), delimiter='\t'))
env = dict(os.environ, ROOTORDER='1', FASTCPL='1', CACHECPL='1', LEGACYFILL='1', FASTLB='1')
for name in ['SPLIT', 'MAXGATES', 'CPLSLACK', 'CHECKCPL', 'CHECKLB']:
    env.pop(name, None)
engine_sha = hashlib.sha256(Path('dagx_lb').read_bytes()).hexdigest()
records = []
for row in rows:
    name = Path(row['file']).stem
    previous = Path('logs/round0325') / (name + '.log')
    reuse = previous.exists() and bool(re.search(r'^RESULT NONE ', previous.read_text(), re.M))
    log = previous if reuse else base / (name + '.log')
    if not log.exists() or not re.search(r'^RESULT ', log.read_text(), re.M):
        # Keep an interrupted attempt for audit.
        if log.exists():
            log.rename(log.with_suffix('.interrupted.' + str(time.time_ns()) + '.log'))
        (base / 'active.json').write_text(json.dumps(dict(file=row['file'], start=time.time(), log=str(log)), indent=2) + '\n')
        with log.open('w') as out:
            out.write(f'RUN skeleton=sk/recompute9_wide/{row["file"]} K=31 node_limit=500000000 seconds=3600 nice=19 address_space=2800000000 ROOTORDER=1 assumptions=A4,A6 engine_sha256={engine_sha}\n')
            out.flush()
            start = time.monotonic()
            try:
                subprocess.run(['./dagx_lb', 'sk/recompute9_wide/' + row['file'], '31', '1', '500000000'],
                               env=env, stdout=out, stderr=subprocess.STDOUT, timeout=3600, check=True)
            except subprocess.TimeoutExpired:
                out.write('RESULT TIMEOUT (unknown; not exhaustive)\n')
            except subprocess.CalledProcessError as exc:
                out.write(f'RESULT ERROR returncode={exc.returncode} (unknown)\n')
            out.write(f'RUN_END elapsed={time.monotonic() - start:.3f}\n')
    txt = log.read_text()
    status = re.findall(r'^RESULT (\w+)', txt, re.M)[-1]
    result = re.search(r'^RESULT .*calls=(\d+).*leaves=(\d+).*time=([\d.]+)s', txt, re.M)
    elapsed = re.search(r'^RUN_END elapsed=([\d.]+)', txt, re.M)
    records.append(dict(file=row['file'], status=status, log=str(log), reused_exhaustive=reuse,
                        node_limit=120000000 if reuse else 500000000,
                        calls=int(result[1]) if result else None,
                        leaves=int(result[2]) if result else None,
                        seconds=float(result[3]) if result else None,
                        elapsed=float(elapsed[1]) if elapsed else None))
    counts = Counter(r['status'] for r in records)
    summary = dict(done=len(records), total=len(rows), counts=dict(counts),
                   reused_exhaustive=sum(r['reused_exhaustive'] for r in records),
                   newly_exhausted=sum(r['status'] == 'NONE' and not r['reused_exhaustive'] for r in records),
                   cumulative_exhausted_of_208=161 + counts['NONE'],
                   new_calls=sum(r['calls'] or 0 for r in records if not r['reused_exhaustive']),
                   new_seconds=sum(r['elapsed'] or r['seconds'] or 0 for r in records if not r['reused_exhaustive']),
                   child_peak_rss_kib=resource.getrusage(resource.RUSAGE_CHILDREN).ru_maxrss,
                   engine_sha256=engine_sha, assumptions=['A4', 'A6'], records=records)
    tmp = base / 'summary.tmp'
    tmp.write_text(json.dumps(summary, indent=2) + '\n')
    tmp.replace(base / 'summary.json')
    print(json.dumps(records[-1]), flush=True)
    if status == 'FOUND':
        subprocess.run(['python3', 'src/verify_log.py', str(log), 'round0430_' + name], check=True)
        raise SystemExit('Candidate produced; inspect strict judge logs.')
(base / 'active.json').unlink(missing_ok=True)
print('ROUND0430 COMPLETE', flush=True)
