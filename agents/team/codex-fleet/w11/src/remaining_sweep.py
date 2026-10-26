#!/usr/bin/env python3
"""Run the remaining prefix counts with two CPUs while c=7 uses two CPUs.

Wait for the existing single-CPU c=8 and c=15 first-prefix sweeps. Then screen
the other comparison counts and keep revisiting unresolved leaves. Preserve
every proof and tree. Stop on a verified candidate or an execution error.
"""
import json
import os
from pathlib import Path
import subprocess
import sys
import time
from prefix_campaign import HERE


def state(c):
    p = HERE/f'independent/cases_v2/c{c}/state.json'
    return json.loads(p.read_text()) if p.exists() else None


def initial_done(c):
    s = state(c)
    return s is not None and all(s['nodes'][name]['status'] not in ('PENDING', 'RUNNING')
                                 for name in s['roots']) and not any(
                                     n['status'] == 'RUNNING' for n in s['nodes'].values())


def decision(s):
    if s is None:
        return 'PENDING'
    statuses = [n['status'] for n in s['nodes'].values()]
    if 'SAT_JUDGE_PASS' in statuses:
        return 'FOUND'
    if 'ERROR' in statuses:
        return 'ERROR'
    return 'COMPLETE' if s['summary']['complete'] else 'PENDING'


def run(c, jobs, budget, round_no, order):
    directory = HERE/f'independent/cases_v2/c{c}'
    directory.mkdir(parents=True, exist_ok=True)
    (directory/'budget.json').write_text(json.dumps({'conflicts':budget})+'\n')
    command = [sys.executable, '-u', str(HERE/'src/prefix_campaign.py'),
               '--c', str(c), '--workers', '2', '--persistent',
               '--conflicts', str(budget), '--max-jobs', str(jobs), '--order', order,
               '--base', str(HERE/f'independent/base_v2/c{c}'),
               '--directory', str(directory)]
    log = HERE/f'logs/sweep_c{c}_round{round_no}.log'
    print(json.dumps(dict(stage='start', c=c, round=round_no, command=command)), flush=True)
    with log.open('w') as out:
        p = subprocess.run(command, stdout=out, stderr=subprocess.STDOUT)
    status = decision(state(c))
    print(json.dumps(dict(stage='end', c=c, round=round_no,
                          returncode=p.returncode, decision=status)), flush=True)
    assert p.returncode == 0 and status != 'ERROR', f'Review {log}'
    subprocess.run([sys.executable, str(HERE/'src/global_status.py'), '--append'], check=True)
    return status


def main():
    if os.getpriority(os.PRIO_PROCESS, 0) < 10:
        os.nice(10-os.getpriority(os.PRIO_PROCESS, 0))
    print('Waiting for c=8 and c=15 first-prefix sweeps; no CPU search runs in this wait.', flush=True)
    while not all(initial_done(c) for c in (8, 15)):
        if any(decision(state(c)) in ('FOUND','ERROR') for c in (7,8,15)):
            return
        time.sleep(15)
    first_order = [1,2,3,4,5,6,9,10,11,12,13,14]
    for c in first_order:
        if decision(state(7)) in ('FOUND','ERROR'):
            return
        if initial_done(c):
            continue
        if run(c, 105, 2000, 0, 'breadth') == 'FOUND':
            return
    round_no = 1
    while True:
        if decision(state(7)) in ('FOUND','ERROR'):
            return
        todo = [c for c in range(1,16) if c != 7 and decision(state(c)) == 'PENDING']
        if not todo:
            print('All managed comparison counts closed; c=7 has its own runner.', flush=True)
            return
        budget = min(20000*round_no, 200000)
        for c in todo:
            if run(c, 256, budget, round_no, 'depth') == 'FOUND':
                return
        round_no += 1


if __name__ == '__main__':
    main()
