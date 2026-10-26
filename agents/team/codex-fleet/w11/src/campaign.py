#!/usr/bin/env python3
"""At most six CPU jobs, inherited nice 10, local output files only."""
from concurrent.futures import ThreadPoolExecutor, as_completed
import json
import os
from pathlib import Path
import subprocess
import sys

HERE = Path(__file__).resolve().parents[1]


def run(name, extra, seconds):
    cmd = [sys.executable, '-u', str(HERE/'src/two_columns.py'), '--tag',
           str(HERE/'runs'/name), '--timeout', str(seconds)]+extra
    with (HERE/'logs'/(name+'.log')).open('w') as log:
        p = subprocess.run(cmd, stdout=log, stderr=subprocess.STDOUT)
    record = dict(name=name, command=cmd, returncode=p.returncode)
    if p.returncode == 0:
        record.update(json.loads((HERE/'runs'/(name+'.json')).read_text()))
        if record['status'] == 'SATISFIABLE':
            from verify import validate
            record['validation'] = validate(HERE/'runs'/(name+'.s'))
    print(json.dumps(record), flush=True)
    return record


def main():
    assert os.getpriority(os.PRIO_PROCESS, 0) >= 10
    jobs = [(f'prefix{i}_c9_k31', ['--prefix', str(i)], 600) for i in range(3)]
    jobs += [(f'raw_{order}_c10_k31', ['--c', '10', '--raw', order], 240)
             for order in ('lex', 'insert', 'round')]
    records = []
    with ThreadPoolExecutor(max_workers=6) as pool:
        future = [pool.submit(run, *job) for job in jobs]
        for f in as_completed(future):
            records.append(f.result())
            (HERE/'runs/summary.json').write_text(json.dumps(records, indent=2)+'\n')


if __name__ == '__main__':
    main()
