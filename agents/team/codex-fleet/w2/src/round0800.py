#!/usr/bin/env python3
"""Run both new repeat families with one CPU search process."""
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
parser.add_argument('--stop', type=int, default=600)
args = parser.parse_args()
resource.setrlimit(resource.RLIMIT_AS, (2800000000, 2800000000))
os.nice(max(0, 19 - os.getpriority(os.PRIO_PROCESS, 0)))
base = Path('logs/round0800')
base.mkdir(exist_ok=True)
env = dict(os.environ, ROOTORDER='1', FASTCPL='1', CACHECPL='1', LEGACYFILL='1', FASTLB='1')
for name in ['SPLIT', 'MAXGATES', 'CPLSLACK', 'CHECKCPL', 'CHECKLB']:
    env.pop(name, None)
engine_sha = hashlib.sha256(Path('dagx_lb').read_bytes()).hexdigest()
plans = []
for c in (10, 11):
    folder = Path(f'sk/round0800_c{c}')
    rows = list(csv.DictReader((folder / 'manifest.tsv').open(), delimiter='\t'))
    assert len(rows) == 300
    plans.append((c, folder, rows))
# Alternate families. Only one solver runs at a time.
records = []
for index in range(300):
    for c, folder, rows in plans:
        if len(records) >= args.stop:
            break
        row = rows[index]
        fn = folder / row['file']
        log = base / f'c{c}_{fn.stem}.log'
        sk_sha = hashlib.sha256(fn.read_bytes()).hexdigest()
        if not log.exists() or not re.search(r'^RESULT ', log.read_text(), re.M):
            if log.exists():
                log.rename(log.with_suffix('.interrupted.' + str(time.time_ns()) + '.log'))
            (base / 'active.json').write_text(json.dumps(dict(file=str(fn), start=time.time(), log=str(log)), indent=2) + '\n')
            with log.open('w') as out:
                out.write(f'RUN skeleton={fn} K=31 node_limit=0 seconds={args.seconds} nice=19 address_space=2800000000 ROOTORDER=1 assumptions=A4,A6 engine_sha256={engine_sha} skeleton_sha256={sk_sha}\n')
                out.flush()
                start = time.monotonic()
                usage = resource.getrusage(resource.RUSAGE_CHILDREN)
                cpu_start = usage.ru_utime + usage.ru_stime
                try:
                    subprocess.run(['./dagx_lb', str(fn), '31', '1', '0'], env=env,
                                   stdout=out, stderr=subprocess.STDOUT,
                                   timeout=args.seconds or None, check=True)
                except subprocess.TimeoutExpired:
                    out.write('RESULT TIMEOUT (unknown; not exhaustive)\n')
                except subprocess.CalledProcessError as exc:
                    out.write(f'RESULT ERROR returncode={exc.returncode} (unknown)\n')
                usage = resource.getrusage(resource.RUSAGE_CHILDREN)
                cpu = usage.ru_utime + usage.ru_stime - cpu_start
                out.write(f'RUN_END elapsed={time.monotonic() - start:.3f} cpu={cpu:.3f} child_peak_rss_kib={usage.ru_maxrss}\n')
        txt = log.read_text()
        statuses = re.findall(r'^RESULT (\w+)', txt, re.M)
        assert len(statuses) == 1
        assert f'engine_sha256={engine_sha}' in txt and f'skeleton_sha256={sk_sha}' in txt
        status = statuses[0]
        result = re.search(r'^RESULT .*calls=(\d+).*leaves=(\d+).*time=([\d.]+)s', txt, re.M)
        end = re.search(r'^RUN_END elapsed=([\d.]+) cpu=([\d.]+) child_peak_rss_kib=(\d+)', txt, re.M)
        records.append(dict(file=str(fn), source=row['source'], comparisons=c,
                            status=status, log=str(log), skeleton_sha256=sk_sha,
                            calls=int(result[1]) if result else None,
                            leaves=int(result[2]) if result else None,
                            seconds=float(result[3]) if result else None,
                            elapsed=float(end[1]) if end else None,
                            cpu=float(end[2]) if end else None,
                            child_peak_rss_kib=int(end[3]) if end else None))
        summary = dict(done=len(records), total=600, counts=dict(Counter(r['status'] for r in records)),
                       groups={str(c2): dict(Counter(r['status'] for r in records if r['comparisons'] == c2)) for c2 in (10, 11)},
                       calls=sum(r['calls'] or 0 for r in records),
                       elapsed=sum(r['elapsed'] or 0 for r in records),
                       cpu=sum(r['cpu'] or 0 for r in records),
                       child_peak_rss_kib=max(r['child_peak_rss_kib'] or 0 for r in records),
                       engine_sha256=engine_sha, assumptions=['A4', 'A6'], records=records)
        tmp = base / 'summary.tmp'
        tmp.write_text(json.dumps(summary, indent=2) + '\n')
        tmp.replace(base / 'summary.json')
        print(json.dumps(records[-1]), flush=True)
        if status == 'FOUND':
            subprocess.run(['python3', 'src/verify_log.py', str(log), f'round0800_c{c}_{fn.stem}'], check=True)
            raise SystemExit('Candidate produced; inspect strict judge logs.')
    if len(records) >= args.stop:
        break
(base / 'active.json').unlink(missing_ok=True)
print('ROUND0800 COMPLETE', flush=True)
