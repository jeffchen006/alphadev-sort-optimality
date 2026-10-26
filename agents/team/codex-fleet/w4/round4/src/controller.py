"""Run one bounded search at a time, then write a complete persistent report."""
from collections import Counter
import fcntl
import hashlib
import json
import os
from pathlib import Path
import resource
import signal
import subprocess
import sys
import time

ROOT = Path(__file__).resolve().parents[2]
BASE = ROOT/'round4'
JUDGE = ROOT.parents[3]/'shared/judge.py'


def digest(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def save(path, data):
    target = Path(path)
    temp = target.with_suffix(target.suffix+'.tmp')
    temp.write_text(json.dumps(data, indent=2)+'\n')
    temp.replace(target)


def records(path):
    rows = []
    for line in Path(path).read_text().splitlines():
        try:
            row = json.loads(line)
            if isinstance(row, dict):
                rows.append(row)
        except ValueError:
            pass
    return rows


def launch(command, log, seconds, env=None, cwd=ROOT):
    start = time.monotonic()
    with Path(log).open('w') as stream:
        process = subprocess.Popen(command, stdout=stream, stderr=subprocess.STDOUT,
                                   start_new_session=True, env=env, cwd=cwd)
        try:
            process.wait(timeout=seconds)
            limit = False
        except subprocess.TimeoutExpired:
            limit = True
            os.killpg(process.pid, signal.SIGTERM)
            try:
                process.wait(timeout=3)
            except subprocess.TimeoutExpired:
                os.killpg(process.pid, signal.SIGKILL)
                process.wait()
    return dict(returncode=process.returncode, external_limit=limit,
                seconds=round(time.monotonic()-start, 3), records=records(log))


def judge(path):
    result = subprocess.run([sys.executable, '-B', str(JUDGE), str(path),
                             '--strict', '--model', 'out'], capture_output=True, text=True)
    output = result.stdout+result.stderr
    log = BASE/'logs'/f'{Path(path).stem}.judge'
    log.write_text(output)
    return dict(path=str(path), returncode=result.returncode, output=output,
                judge_log=str(log), sha256=digest(path))


def accept(checked, k):
    if checked['returncode'] or not checked['output'].startswith('PASS ') or k > 31:
        return False
    target = BASE/'verified'/Path(checked['path']).name
    target.write_bytes(Path(checked['path']).read_bytes())
    memory = target.with_name(target.stem+'_mem.s')
    subprocess.run([sys.executable, '-B', str(ROOT/'src/to_mem.py'),
                    str(target), str(memory)], check=True)
    mem = subprocess.run([sys.executable, '-B', str(JUDGE), str(memory),
                          '--strict', '--model', 'mem'], capture_output=True, text=True)
    (BASE/'logs'/f'{memory.stem}.judge').write_text(mem.stdout+mem.stderr)
    checked['memory_judge'] = dict(path=str(memory), returncode=mem.returncode,
                                   output=mem.stdout+mem.stderr)
    results = ROOT/'RESULTS.md'
    results.write_text(f'FOUND k={k} strict out PASS: {target}\n\n'+results.read_text())
    return True


def report(finished=False):
    rows = json.loads((BASE/'logs/retry900_summary.json').read_text()) if (BASE/'logs/retry900_summary.json').exists() else []
    repairs = json.loads((BASE/'repair/summary.json').read_text()) if (BASE/'repair/summary.json').exists() else []
    tasks = json.loads((BASE/'logs/retry900_tasks.json').read_text())
    result = dict(finished=finished, retry_planned=len(tasks), retry_completed=len(rows),
                  retry_pending=len(tasks)-len(rows), retry_statuses=dict(Counter(r['status'] for r in rows)),
                  retry_seconds=round(sum(r['seconds'] for r in rows), 3),
                  matching_initial_formula_hashes=sum(r.get('initial_formula_matches',False) for r in rows),
                  repair_completed=len(repairs), repair_statuses=dict(Counter(r['status'] for r in repairs)),
                  maximum_measured_job_rss_kib=max((x.get('peak_job_rss_kib',0) for r in rows
                      for x in r['records']),default=0),
                  solver_cpu_seconds=round(sum(next((x.get('child_cpu_seconds',0)
                      for x in reversed(r['records']) if x.get('phase')=='kissat_result'),0) for r in rows),3),
                  assumptions=['G1','G2','G3','G4','A2','A11'],
                  source_sha256={str(p.relative_to(ROOT)):digest(p) for p in (BASE/'src').glob('*.py')},
                  strict_passes=[j for r in rows+repairs for j in r.get('judges',[])
                                 if not j['returncode'] and j['output'].startswith('PASS ')])
    controls = BASE/'repair/controls.json'
    if controls.exists():
        result['strict_passes'] += [j for j in json.loads(controls.read_text()).get('judges',[])
                                   if not j['returncode'] and j['output'].startswith('PASS ')]
    save(BASE/'logs/progress.json',result)
    lines = ['\n### Round-4 '+('completed results' if finished else 'progress')+'\n',
             f"The 900-second retry batch has completed {len(rows)} of {len(tasks)} queries. "
             f"Statuses: {result['retry_statuses']}. "
             f"There are {result['retry_pending']} queries pending.",
             '',f"The retry records contain {result['matching_initial_formula_hashes']} matching initial formula hashes. "
             f"Recorded query wall time is {result['retry_seconds']} seconds. "
             f"Recorded Kissat CPU time is {result['solver_cpu_seconds']} seconds. "
             f"The largest sampled combined resident set is {result['maximum_measured_job_rss_kib']} KiB.",
             '',f"The repair batch has completed {len(repairs)} windows. Statuses: {result['repair_statuses']}.",
             '', 'Assumptions: [G1,G2,G3,G4,A2,A11]. These searches test local reachability (A11) '
             'within finite register sets (A2). Comparison operands remain free. '
             'The searches do not fix the value skeleton in A4 or the term pool in A8. '
             'Each UNSAT result excludes only its stated window and finite register set. '
             'Every time or resource limit is UNKNOWN. No global lower bound follows.',
             '', 'Complete records: `round4/logs/retry900_summary.json`, '
             '`round4/repair/summary.json`, and `round4/logs/progress.json`.', '']
    if result['strict_passes']:
        lines += ['Every round-4 strict PASS file:', '']
        lines += [f'- `{j["path"]}`: `{j["output"].splitlines()[0]}`; log `{j["judge_log"]}`.'
                  for j in result['strict_passes']]
        lines += ['']
    else:
        lines += ['No new strict PASS file is recorded.', '']
    if finished:
        save(BASE/'logs/final_audit.json',result)
        if not (BASE/'logs/report_appended').exists():
            with (ROOT/'RESULTS.md').open('a') as stream:
                stream.write('\n'.join(lines))
            (BASE/'logs/report_appended').write_text(str(time.time())+'\n')
    (BASE/'STATUS.md').write_text('\n'.join(lines))
    return result


def retries():
    summary_path = BASE/'logs/retry900_summary.json'
    rows = json.loads(summary_path.read_text()) if summary_path.exists() else []
    done = {row['tag'] for row in rows}
    for query in json.loads((BASE/'logs/retry900_tasks.json').read_text()):
        tag = query['tag']
        if tag in done:
            continue
        task = query['task'].copy()
        command = [sys.executable,'-B',str(BASE/'src/kissat_window.py'),task.pop('seed'),
                   '--out',str(BASE/'candidates'/f'{tag}.s')]
        task.pop('solver',None)
        for key, value in task.items():
            if value is False:
                continue
            command.append('--'+key.replace('_','-'))
            if value is not True:
                command.extend(map(str,value if isinstance(value,list) else [value]))
        env = os.environ.copy()
        env['W4_KISSAT_PHASES'] = str(int(query['phase_renaming']))
        env['W4_EXPECTED_INITIAL_HASH'] = query['previous_formula_sha256']
        save(BASE/'logs/active.json',dict(tag=tag,started_unix=time.time(),limit_seconds=900))
        print(json.dumps({'phase':'start','tag':tag,'limit_seconds':900}),flush=True)
        row = launch(command,BASE/'logs'/f'{tag}.log',940,env)
        row.update(tag=tag,query=query,command=command)
        solves = [r for r in row['records'] if r.get('phase')=='solve']
        row['status'] = {'False':'UNSAT','None':'UNKNOWN'}.get(solves[-1]['status'],'ERROR') if solves else 'ERROR'
        first = next((r for r in row['records'] if r.get('phase')=='kissat_result'),{})
        row['initial_formula_matches'] = first.get('cnf_sha256') == query['previous_formula_sha256']
        if row['external_limit']:
            row['status'] = 'UNKNOWN'
        if row['status']=='UNSAT':
            assert row['initial_formula_matches'] and not row['returncode']
            last = next(r for r in reversed(row['records']) if r.get('phase')=='kissat_result')
            assert last['returncode']==20 and last['status']=='False'
        found = False
        row['judges'] = []
        seen = set()
        for record in row['records']:
            if 'path' not in record or record['path'] in seen:
                continue
            seen.add(record['path'])
            checked = judge(record['path'])
            row['judges'].append(checked)
            found |= accept(checked,record['k'])
        if any(r.get('status')=='CANDIDATE' for r in row['records']):
            row['status'] = 'PASS' if found else 'REJECTED'
        rows.append(row)
        save(summary_path,rows)
        report()
        print(json.dumps({'phase':'end','tag':tag,'status':row['status'],
                          'seconds':row['seconds'],'initial_formula_matches':row['initial_formula_matches']}),flush=True)
        if found:
            return True
    return False


def main():
    os.chdir(ROOT)
    assert os.getpriority(os.PRIO_PROCESS,0)==19
    os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
    resource.setrlimit(resource.RLIMIT_AS,(2800*1024**2,2800*1024**2))
    lock = (BASE/'logs/controller.lock').open('w')
    fcntl.flock(lock,fcntl.LOCK_EX|fcntl.LOCK_NB)
    save(BASE/'logs/controller.json',dict(pid=os.getpid(),affinity=sorted(os.sched_getaffinity(0)),
                                        nice=os.getpriority(os.PRIO_PROCESS,0),started_unix=time.time()))
    try:
        found = retries()
        if not found:
            from repair_windows import run
            run()
        report(finished=True)
        print(json.dumps({'phase':'finished'}),flush=True)
    except BaseException as error:
        save(BASE/'logs/controller_error.json',dict(type=type(error).__name__,message=str(error)))
        report()
        raise


if __name__=='__main__':
    main()
