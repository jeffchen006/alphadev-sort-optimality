#!/usr/bin/env python3
"""Run exact fixed-skeleton routing jobs within a fixed process budget."""
import argparse
import concurrent.futures
import json
import re
from pathlib import Path
import subprocess
import time

p = argparse.ArgumentParser()
p.add_argument('directory')
p.add_argument('logdir')
p.add_argument('--jobs', type=int, default=6)
p.add_argument('--nodes', type=int, default=3000000)
p.add_argument('--seconds', type=int, default=120)
p.add_argument('--cost', type=int, default=31)
p.add_argument('--engine', default='./dagx')
a = p.parse_args()
out = Path(a.logdir)
out.mkdir(parents=True, exist_ok=True)
files = sorted(Path(a.directory).glob('*.txt'))

def run(fn):
    dst = out / (fn.stem + '.log')
    if dst.exists() and 'RESULT' in dst.read_text():
        return fn.name, dst.read_text().splitlines()[-1]
    t0 = time.monotonic()
    with dst.open('w') as f:
        try:
            subprocess.run(['nice', '-n', '10', a.engine, str(fn), str(a.cost),
                            '1', str(a.nodes)], stdout=f, stderr=subprocess.STDOUT,
                           timeout=a.seconds, check=True)
        except subprocess.TimeoutExpired:
            f.write('RESULT TIMEOUT seconds=%d (not exhaustive)\n' % a.seconds)
        except subprocess.CalledProcessError as ex:
            f.write('RESULT ERROR returncode=%d\n' % ex.returncode)
    result = dst.read_text().splitlines()[-1]
    return fn.name, result

counts = {}
total_calls = 0
t0 = time.monotonic()
with concurrent.futures.ThreadPoolExecutor(max_workers=a.jobs) as pool:
    for i, (name, result) in enumerate(pool.map(run, files), 1):
        status = result.split()[1]
        counts[status] = counts.get(status, 0) + 1
        match = re.search(r'calls=(\d+)',result)
        if match:
            total_calls += int(match.group(1))
        if i % 20 == 0 or status in ('FOUND', 'ERROR') or i == len(files):
            print(json.dumps(dict(done=i, total=len(files), counts=counts,calls=total_calls,
                                  seconds=round(time.monotonic()-t0,1),
                                  last=name, result=result)), flush=True)
print('BATCH COMPLETE', flush=True)
