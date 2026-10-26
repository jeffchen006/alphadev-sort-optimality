#!/usr/bin/env python3
"""Run a reproducible window batch with no more than two single-threaded jobs."""
import argparse
import json
import os
import signal
from pathlib import Path
import subprocess
import sys
import time

BASE = Path(__file__).resolve().parents[1]


def tasks(kind):
    palette = 'palette_c8_k32.s'
    c8c = 'c8c_len32_c29288.s'
    cond = 'c8_903a0e9b56d0fdc7.s'
    lowmov = 'c8_2dfea391c9fdd3bb.s'
    walk = 'c8_walk4_final.s'
    if kind == 'controls':
        for name in (palette, cond):
            yield dict(seed=name, a=8, b=32, delta=0, control=True, all_cases=True, seconds=120)
        yield dict(seed=palette, a=0, b=32, delta=0, control=True,
                   all_cases=True, wrong_output=True, seconds=120)
        yield dict(seed=palette, a=8, b=32, delta=0, mode='dest', outputs='seed',
                   all_cases=True, prefer_seed=True, seconds=120)
        return
    if kind == 'templates':
        # These windows all cross preparation/merge (boundary about 15--16).
        for name, a, b, deletes in [
            (c8c, 9, 32, [0, 3, 6, 10]),
            (palette, 8, 32, [1, 5, 8, 12]),
            (cond, 9, 32, [1, 4, 7, 9]),
            (lowmov, 8, 32, [1, 3, 8, 17]),
            (walk, 9, 32, [1, 4, 8, 12]),
        ]:
            for delete in deletes:
                yield dict(seed=name, a=a, b=b, delete=delete, mode='dest', cases=12, seconds=120,
                           cmp_order=True, no_self_write=True, prefer_seed=True)
        return
    if kind == 'crossing':
        for name, a, b, deletes in [
            (c8c, 9, 21, [0, 3, 6, 10]),
            (palette, 8, 25, [1, 5, 8, 12]),
            (cond, 9, 25, [1, 4, 7, 9]),
            (lowmov, 8, 26, [1, 3, 8, 17]),
            (walk, 9, 25, [1, 4, 8, 12]),
        ]:
            for delete in deletes:
                yield dict(seed=name, a=a, b=b, delete=delete, mode='dest', cases=16,
                           seconds=120, no_self_write=True, prefer_seed=True, outputs='seed')
        return
    if kind == 'scheduled':
        for name, a, b, delete in [(c8c, 9, 32, 0), (palette, 8, 32, 8),
                                   (cond, 9, 32, 7), (lowmov, 8, 32, 17),
                                   (walk, 9, 32, 4)]:
            yield dict(seed=name, a=a, b=b, delete=delete, mode='cmp', cases=12,
                       seconds=300, cmp_order=True, no_self_write=True, prefer_seed=True, extra=1)
        return
    if kind == 'classtimes':
        for name, a, b, deletes in [
            (c8c, 9, 21, [0, 3, 6, 10]),
            (palette, 8, 25, [1, 5, 8, 12]),
            (cond, 9, 25, [1, 4, 7, 9]),
            (lowmov, 8, 26, [1, 3, 8, 17]),
            (walk, 9, 25, [1, 4, 8, 12]),
        ]:
            for delete in deletes:
                yield dict(seed=name, a=a, b=b, delete=delete, mode='class', cases=12,
                           seconds=90, no_self_write=True, prefer_seed=True, outputs='times', extra=1)
        return
    if kind == 'binary':
        for name, a, b, delete, nc in [(palette,8,32,8,6), (c8c,9,32,0,6)]:
            yield dict(seed=name, a=a, b=b, delete=delete, mode='free', comparisons=nc,
                       seconds=300, case_set='binary', extra=1, cmp_order=True,
                       no_self_write=True, prefer_seed=True,
                       solver='cadical300' if name == palette else 'cadical195')
        for name, a, b, delete in [(cond,9,25,7), (lowmov,8,26,17), (walk,9,25,4)]:
            yield dict(seed=name, a=a, b=b, delete=delete, mode='class',
                       seconds=300, case_set='binary', extra=1,
                       no_self_write=True, prefer_seed=True,
                       solver='glucose4' if name == cond else 'cadical300' if name == lowmov else 'cadical195')
        return
    if kind == 'tailfree':
        yield dict(seed=lowmov, a=8, b=32, delete=17, mode='class',
                   seconds=600, case_set='binary', case_file=str(BASE/'logs/binary03_cex.json'),
                   extra=1, cmp_order=True, no_self_write=True, prefer_seed=True, solver='cadical300')
        return
    if kind == 'tailone':
        yield dict(seed=lowmov, a=8, b=32, delete=17, mode='class', refine=1,
                   seconds=300, case_set='binary', case_file=str(BASE/'logs/binary03_cex.json'),
                   extra=1, cmp_order=True, no_self_write=True, prefer_seed=True, solver='cadical300')
        return
    if kind == 'dense':
        yield dict(seed=c8c, a=9, b=32, delete=0, mode='class', seconds=300,
                   case_set='ternary', extra=1, cmp_order=True, no_self_write=True,
                   prefer_seed=True, solver='glucose4')
        yield dict(seed=lowmov, a=8, b=32, delete=17, mode='class', seconds=300,
                   all_cases=True, extra=1, cmp_order=True, no_self_write=True,
                   prefer_seed=True, solver='cadical300')
        return
    if kind == 'deletion_control':
        yield dict(seed='control_padded33.s', a=8, b=33, delete=8, delta=1,
                   control=True, outputs='seed', all_cases=True, seconds=30)
        return
    raise ValueError(kind)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('batch', choices=['controls','templates','crossing','scheduled','classtimes','binary','tailfree','tailone','dense','deletion_control'])
    ap.add_argument('--jobs', type=int, default=2)
    ap.add_argument('--indices', type=int, nargs='*', help='Run only these batch indices.')
    ap.add_argument('--seconds', type=float, help='Override each query time limit.')
    args = ap.parse_args()
    assert 1 <= args.jobs <= 2
    assert os.getpriority(os.PRIO_PROCESS, 0) == 19, 'Run with nice -n 19'
    queue = list(enumerate(tasks(args.batch)))
    if args.indices is not None:
        queue = [(i, task) for i, task in queue if i in args.indices]
    if args.seconds is not None:
        for _, task in queue:
            task['seconds'] = args.seconds
    (BASE/'logs'/f'{args.batch}_tasks.json').write_text(json.dumps(queue, indent=2)+'\n')
    active = []
    summary = []
    began = time.monotonic()
    while queue or active:
        while queue and len(active) < args.jobs:
            index, task = queue.pop(0)
            tag = f'{args.batch}_{index:02d}'
            cmd = [sys.executable, str(BASE/'src/window_cnf.py'), str(BASE/'seeds'/task['seed']),
                   '--out', str(BASE/'candidates'/f'{tag}.s'), '--random-seed', str(4200+index)]
            for key, value in task.items():
                if key == 'seed':
                    continue
                key = '--'+key.replace('_','-')
                if value is True:
                    cmd.append(key)
                else:
                    cmd.extend([key, str(value)])
            log = open(BASE/'logs'/f'{tag}.log', 'w')
            # External timeout also caps an unexpectedly long SAT budget slice.
            process = subprocess.Popen(['timeout','-k','5', str(int(task['seconds'])+30), *cmd],
                                       stdout=log, stderr=subprocess.STDOUT, start_new_session=True)
            active.append((tag, task, process, log, time.monotonic()))
            print(json.dumps({'event':'start','tag':tag,'task':task}), flush=True)
        for entry in active[:]:
            tag, task, process, log, started = entry
            code = process.poll()
            if code is None:
                continue
            log.close()
            records = []
            for line in (BASE/'logs'/f'{tag}.log').read_text().splitlines():
                try:
                    records.append(json.loads(line))
                except ValueError:
                    pass
            result = dict(tag=tag, task=task, returncode=code,
                          elapsed=round(time.monotonic()-started,3), records=records)
            candidate = next((r for r in records if r.get('status') == 'CANDIDATE'), None)
            if not candidate:
                candidate = next((r for r in reversed(records) if r.get('phase') == 'near'), None)
            if candidate:
                judge = '/path/to/repo/shared/judge.py'
                checked = subprocess.run([sys.executable, judge, candidate['path'], '--strict', '--model', 'out'],
                                         capture_output=True, text=True)
                (BASE/'logs'/f'{tag}.judge').write_text(checked.stdout+checked.stderr)
                result['judge'] = {'code':checked.returncode, 'output':checked.stdout+checked.stderr}
                if checked.returncode == 0 and 'PASS ' in checked.stdout and candidate['k'] <= 31:
                    memory = BASE/'verified'/f'{tag}_mem.s'
                    subprocess.run([sys.executable, str(BASE.parent/'src/to_mem.py'), candidate['path'], str(memory)], check=True)
                    checked_mem = subprocess.run([sys.executable, judge, str(memory), '--strict', '--model', 'mem'],
                                                 capture_output=True, text=True)
                    (BASE/'logs'/f'{tag}_mem.judge').write_text(checked_mem.stdout+checked_mem.stderr)
                    result['memory_judge'] = {'code':checked_mem.returncode,
                                              'output':checked_mem.stdout+checked_mem.stderr}
                    results = BASE.parent/'RESULTS.md'
                    results.write_text(f"FOUND k={candidate['k']} strict out PASS: {candidate['path']}\n\n"+results.read_text())
                    queue.clear()
                    for other in active:
                        if other is not entry and other[2].poll() is None:
                            os.killpg(other[2].pid, signal.SIGTERM)
            summary.append(result)
            print(json.dumps({'event':'end',**result}), flush=True)
            active.remove(entry)
            (BASE/'logs'/f'{args.batch}_summary.json').write_text(json.dumps(summary, indent=2)+'\n')
        time.sleep(0.2)
    print(json.dumps({'event':'complete','queries':len(summary),
                      'seconds':round(time.monotonic()-began,3)}), flush=True)


if __name__ == '__main__':
    main()
