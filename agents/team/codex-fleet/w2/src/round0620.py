#!/usr/bin/env python3
"""Route 300 new c=10 repeated-comparison skeletons, one job at a time."""
import argparse
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

parser = argparse.ArgumentParser()
parser.add_argument('--seconds', type=int, default=3600)
parser.add_argument('--start', type=int, default=1)
parser.add_argument('--stop', type=int, default=300)
args = parser.parse_args()
resource.setrlimit(resource.RLIMIT_AS, (2800000000, 2800000000))
os.nice(max(0, 19 - os.getpriority(os.PRIO_PROCESS, 0)))
base = Path('logs/round0620')
base.mkdir(exist_ok=True)
rows = list(csv.DictReader(Path('sk/round0620/manifest.tsv').open(), delimiter='\t'))
assert len(rows) == 300
env = dict(os.environ, ROOTORDER='1', FASTCPL='1', CACHECPL='1', LEGACYFILL='1', FASTLB='1')
for name in ['SPLIT', 'MAXGATES', 'CPLSLACK', 'CHECKCPL', 'CHECKLB']:
    env.pop(name, None)
engine_sha = hashlib.sha256(Path('dagx_lb').read_bytes()).hexdigest()
records = []
for number, row in enumerate(rows, 1):
    if number > args.stop:
        break
    fn = Path('sk/round0620') / row['file']
    log = base / (fn.stem + '.log')
    if number >= args.start and (not log.exists() or not re.search(r'^RESULT ', log.read_text(), re.M)):
        if log.exists():
            log.rename(log.with_suffix('.interrupted.' + str(time.time_ns()) + '.log'))
        (base / 'active.json').write_text(json.dumps(dict(file=str(fn), start=time.time(), log=str(log)), indent=2) + '\n')
        with log.open('w') as out:
            out.write(f'RUN skeleton={fn} K=31 node_limit=0 seconds={args.seconds} nice=19 address_space=2800000000 ROOTORDER=1 assumptions=A4,A6 engine_sha256={engine_sha}\n')
            out.flush()
            start = time.monotonic()
            try:
                subprocess.run(['./dagx_lb', str(fn), '31', '1', '0'], env=env,
                               stdout=out, stderr=subprocess.STDOUT,
                               timeout=args.seconds or None, check=True)
            except subprocess.TimeoutExpired:
                out.write('RESULT TIMEOUT (unknown; not exhaustive)\n')
            except subprocess.CalledProcessError as exc:
                out.write(f'RESULT ERROR returncode={exc.returncode} (unknown)\n')
            out.write(f'RUN_END elapsed={time.monotonic() - start:.3f}\n')
    if not log.exists():
        continue
    txt = log.read_text()
    statuses = re.findall(r'^RESULT (\w+)', txt, re.M)
    if not statuses:
        continue
    status = statuses[-1]
    assert 'engine_sha256=' + engine_sha in txt
    result = re.search(r'^RESULT .*calls=(\d+).*leaves=(\d+).*time=([\d.]+)s', txt, re.M)
    elapsed = re.search(r'^RUN_END elapsed=([\d.]+)', txt, re.M)
    records.append(dict(file=str(fn), source=row['source'], status=status, log=str(log),
                        calls=int(result[1]) if result else None,
                        leaves=int(result[2]) if result else None,
                        seconds=float(result[3]) if result else None,
                        elapsed=float(elapsed[1]) if elapsed else None))
    summary = dict(done=len(records), total=len(rows), counts=dict(Counter(r['status'] for r in records)),
                   calls=sum(r['calls'] or 0 for r in records),
                   elapsed=sum(r['elapsed'] or 0 for r in records),
                   child_peak_rss_kib=resource.getrusage(resource.RUSAGE_CHILDREN).ru_maxrss,
                   engine_sha256=engine_sha, assumptions=['A4', 'A6'], records=records)
    tmp = base / 'summary.tmp'
    tmp.write_text(json.dumps(summary, indent=2) + '\n')
    tmp.replace(base / 'summary.json')
    print(json.dumps(records[-1]), flush=True)
    if status == 'FOUND':
        subprocess.run(['python3', 'src/verify_log.py', str(log), 'round0620_' + fn.stem], check=True)
        raise SystemExit('Candidate produced; inspect strict judge logs.')
(base / 'active.json').unlink(missing_ok=True)
print('ROUND0620 COMPLETE', flush=True)
