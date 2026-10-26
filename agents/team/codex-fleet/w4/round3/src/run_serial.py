#!/usr/bin/env python3
"""Run one bounded Kissat query at a time and judge every decoded program."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import signal
import subprocess
import sys
import time

BASE = Path(__file__).resolve().parents[1]
JUDGE = '/path/to/repo/shared/judge.py'


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('tasks')
    ap.add_argument('--indices', type=int, nargs='*')
    args = ap.parse_args()
    assert os.getpriority(os.PRIO_PROCESS, 0) == 19
    tasks_file = Path(args.tasks)
    name = tasks_file.stem.removesuffix('_tasks')
    if name == 'variants_fixed' and (BASE/'logs/frontier_tasks.json').exists():
        # The existing finish driver launches this file only after its phased
        # positive control. Resume the three prior CEGIS frontiers first.
        with (BASE/'logs/frontier_batch.log').open('w') as stream:
            subprocess.run([sys.executable,str(BASE/'src/run_serial.py'),
                            str(BASE/'logs/frontier_tasks.json')],
                           stdout=stream,stderr=subprocess.STDOUT,check=True)
        if (BASE.parent/'RESULTS.md').read_text().startswith('FOUND'):
            print(json.dumps({'phase':'complete','queries':0,'reason':'frontier_found'}),flush=True)
            return
    if name == 'variants_broad':
        # Check comparison normalization at a window/suffix boundary. The
        # suffix starts with cmp, so it cannot use the normalized window flags.
        control=BASE/'candidates/control_normalized_boundary32.s'
        with (BASE/'logs/control_normalized_boundary32.log').open('w') as stream:
            subprocess.run([sys.executable,str(BASE/'src/kissat_window.py'),
                            str(BASE.parent/'round2/seeds/palette_c8_k32.s'),
                            '--a','8','--b','25','--delta','0','--mode','dest',
                            '--outputs','seed','--all-cases','--cmp-order','--prefer-seed',
                            '--seconds','60','--random-seed','4200','--out',str(control)],
                           stdout=stream,stderr=subprocess.STDOUT,timeout=100,check=True)
        assert control.exists(),'Boundary normalization control did not produce a program'
        checked=subprocess.run([sys.executable,JUDGE,str(control),'--strict','--model','out'],
                               capture_output=True,text=True,check=True)
        (BASE/'logs/control_normalized_boundary32.judge').write_text(checked.stdout+checked.stderr)
    summary_path = BASE/'logs'/f'{name}_summary.json'
    summary = json.loads(summary_path.read_text()) if summary_path.exists() else []
    done = {r['tag'] for r in summary}
    began = time.monotonic()
    for ix, query in enumerate(json.loads(tasks_file.read_text())):
        if args.indices is not None and ix not in args.indices:
            continue
        tag = name+'_'+query['tag']
        if tag in done:
            continue
        task = query['task'].copy()
        seed = task.pop('seed')
        command = [sys.executable, str(BASE/'src/kissat_window.py'), seed,
                   '--out', str(BASE/'candidates'/f'{tag}.s')]
        task.pop('solver', None)
        for key, value in task.items():
            if value is False:
                continue
            command.append('--'+key.replace('_','-'))
            if value is not True:
                command.extend(map(str, value if isinstance(value,list) else [value]))
        log = BASE/'logs'/f'{tag}.log'
        print(json.dumps({'phase':'start', 'tag':tag, 'task':query['task'],
                          'started_unix':time.time()}), flush=True)
        start = time.monotonic()
        with log.open('w') as stream:
            process = subprocess.Popen(command, stdout=stream, stderr=subprocess.STDOUT,
                                       start_new_session=True)
            try:
                process.wait(timeout=task['seconds']+40)
            except subprocess.TimeoutExpired:
                os.killpg(process.pid, signal.SIGTERM)
                try:
                    process.wait(timeout=3)
                except subprocess.TimeoutExpired:
                    os.killpg(process.pid, signal.SIGKILL)
                    process.wait()
        records = []
        for line in log.read_text().splitlines():
            try:
                records.append(json.loads(line))
            except ValueError:
                pass
        result = {'tag':tag, 'task':query['task'], 'returncode':process.returncode,
                  'seconds':round(time.monotonic()-start,3), 'records':records,
                  'seed_sha256':hashlib.sha256(Path(seed).read_bytes()).hexdigest()}
        result['status'] = next((r['status'] for r in reversed(records)
                                 if r.get('phase')=='solve'), 'UNKNOWN')
        if any(r.get('status')=='CANDIDATE' for r in records):
            result['status'] = 'CANDIDATE'
        judged = set()
        found = False
        for record in records:
            if 'path' not in record or record['path'] in judged:
                continue
            judged.add(record['path'])
            checked = subprocess.run([sys.executable, JUDGE, record['path'], '--strict', '--model','out'],
                                     capture_output=True, text=True)
            judge_log = BASE/'logs'/f'{Path(record["path"]).stem}.judge'
            judge_log.write_text(checked.stdout+checked.stderr)
            result.setdefault('judges',[]).append({'path':record['path'], 'returncode':checked.returncode,
                                                   'output':checked.stdout+checked.stderr})
            if checked.returncode == 0 and 'PASS ' in checked.stdout and record['k'] <= 31:
                found = True
                dest = BASE/'verified'/Path(record['path']).name
                dest.write_bytes(Path(record['path']).read_bytes())
                memory = dest.with_name(dest.stem+'_mem.s')
                subprocess.run([sys.executable, str(BASE.parent/'src/to_mem.py'), str(dest),str(memory)],check=True)
                mem = subprocess.run([sys.executable,JUDGE,str(memory),'--strict','--model','mem'],
                                     capture_output=True,text=True)
                (BASE/'logs'/f'{memory.stem}.judge').write_text(mem.stdout+mem.stderr)
                result['memory_judge']={'returncode':mem.returncode, 'output':mem.stdout+mem.stderr}
                results = BASE.parent/'RESULTS.md'
                results.write_text(f'FOUND k={record["k"]} strict out PASS: {dest}\n\n'+results.read_text())
        summary.append(result)
        summary_path.write_text(json.dumps(summary,indent=2)+'\n')
        print(json.dumps({'phase':'end','tag':tag,'status':result['status'],
                          'seconds':result['seconds'],'judges':result.get('judges',[])}),flush=True)
        if found:
            break
    print(json.dumps({'phase':'complete','queries':len(summary),
                      'seconds':round(time.monotonic()-began,3)}),flush=True)


if __name__ == '__main__':
    main()
