"""Serial whole-core routing campaign with retained formulas and certificates."""
from collections import Counter
import fcntl
import hashlib
import itertools
import json
import os
from pathlib import Path
import resource
import signal
import subprocess
import sys
import time

BASE = Path(__file__).resolve().parents[1]
WORKER = BASE.parents[1]
PROJECT = WORKER.parents[3]
CHECKER = PROJECT/'agents/proofs/tools/bin/drat-trim'
sys.path.insert(0, str(BASE/'src'))
from reference_window import read, concrete, CASES


def canonical_spine(seed, maps):
    p, used = read(seed)
    _, states = concrete(p, used)
    pairs = [(states[i][0][d], states[i][0][s]) for i,(o,d,s) in enumerate(p) if o == 1]
    best = None
    maxima = [max(case) for case in CASES]
    for indices, reverse in maps:
        encoded = []
        for pair in pairs:
            columns = [bytes((maxima[t]-col[q] if reverse else col[q])
                             for t,q in enumerate(indices)) for col in pair]
            encoded.extend(sorted(columns))
        signature = b''.join(encoded)
        if best is None or signature < best:
            best = signature
    return hashlib.sha256(best).hexdigest()


def digest(path):
    h = hashlib.sha256()
    with Path(path).open('rb') as f:
        while block := f.read(1024**2):
            h.update(block)
    return h.hexdigest()


def save(path, data):
    path = Path(path)
    tmp = path.with_suffix('.tmp')
    tmp.write_text(json.dumps(data, indent=2)+'\n')
    tmp.replace(path)


def launch(command, log, seconds, env=None):
    began = time.monotonic()
    with Path(log).open('w') as stream:
        p = subprocess.Popen(command, stdout=stream, stderr=subprocess.STDOUT,
                             env=env, start_new_session=True, cwd=WORKER)
        try:
            p.wait(timeout=seconds)
            limited = False
        except subprocess.TimeoutExpired:
            limited = True
            os.killpg(p.pid, signal.SIGTERM)
            try:
                p.wait(timeout=2)
            except subprocess.TimeoutExpired:
                os.killpg(p.pid, signal.SIGKILL)
                p.wait()
    records = []
    for line in Path(log).read_text().splitlines():
        try:
            row = json.loads(line)
            if isinstance(row, dict):
                records.append(row)
        except ValueError:
            pass
    return dict(returncode=p.returncode, limited=limited, command=command,
                seconds=round(time.monotonic()-began, 3), records=records)


def prepare():
    path = BASE/'logs/tasks.json'
    if path.exists():
        return json.loads(path.read_text())
    tasks = []
    inventory = []
    case_index = {tuple(case):i for i,case in enumerate(CASES)}
    maps = []
    for permutation in itertools.permutations(range(5)):
        for reverse in [False, True]:
            maps.append(([case_index[tuple(max(case)-case[j] if reverse else case[j]
                                           for j in permutation)] for case in CASES], reverse))
    for number, source in enumerate(sorted((WORKER/'round6/seeds').glob('c8_*.s'))):
        seed = BASE/'seeds'/source.name
        seed.write_bytes(source.read_bytes())
        p, used = read(seed)
        assert len(p) == 32 and sum(x[0] == 1 for x in p) == 8
        cmp_positions = [i for i, x in enumerate(p) if x[0] == 1]
        movs = [i for i, x in enumerate(p) if x[0] == 0]
        deletions = [movs[0]]
        inventory.append(dict(seed=str(seed), source=str(source), sha256=digest(seed),
                              registers=used-1, cmp_positions=cmp_positions, deletions=deletions,
                              canonical_spine=canonical_spine(seed,maps)))
        for d in deletions:
            tasks.append(dict(tag=f'early_v{number:02d}_d{d:02d}', seed=str(seed),
                              seed_sha256=digest(seed), delete=d, registers=used+1,
                              seconds=60, mode='free_dest', binary=True, group='target'))
    # Retry only the six unknown, free-destination queries from the first pass.
    previous = json.loads((WORKER/'round6/logs/summary.json').read_text())
    for row in previous:
        old = row['task']
        if old['mode'] != 'free_dest' or row['status'] != 'UNKNOWN':
            continue
        seed = BASE/'seeds'/Path(old['seed']).name
        tasks.insert(0, dict(old, tag='retry_'+old['tag'], seed=str(seed),
                             binary=True, seconds=120, retry_source=old['tag']))
    # Input permutations, order reversal, and independent cmp orientation
    # changes preserve this free-routing domain. Keep one physical query for
    # each equal schedule, register cap, and normalized comparison skeleton.
    seed_rows = {row['seed']:row for row in inventory}
    seen = {}
    unique, duplicates = [], []
    for task in tasks:
        row = seed_rows[task['seed']]
        d = task['delete']
        shape = tuple(i-(i>d) for i in row['cmp_positions'])
        key = (row['canonical_spine'],shape,task['registers'])
        if key in seen:
            duplicates.append(dict(skipped=task['tag'], representative=seen[key], key=key))
        else:
            seen[key] = task['tag']
            unique.append(task)
    save(BASE/'logs/symmetry_duplicates.json',duplicates)
    tasks = unique
    large = dict(tasks[0], tag='large_registers_'+tasks[0]['tag'],
                 registers=16, seconds=180, large_register_test=True)
    tasks.append(large)
    save(BASE/'logs/seeds.json', inventory)
    save(path, tasks)
    return tasks


def run_task(task):
    assert digest(task['seed']) == task['seed_sha256']
    tag = task['tag']
    stem = BASE/'cnf'/tag
    output = BASE/'candidates'/f'{tag}.s'
    env = os.environ.copy()
    env['W4_QUERY_STEM'] = str(stem)
    env['W4_QUERY_DEADLINE'] = str(time.monotonic()+task['seconds'])
    command = [sys.executable, '-B', str(BASE/'src/search.py'), task['seed'], str(output),
               '--registers', str(task['registers'])]
    if task.get('delete') is not None:
        command += ['--delete', str(task['delete'])]
    if task['mode'] == 'free_dest':
        command += ['--free-dest']
    elif task.get('canonical'):
        command += ['--free-dest']
    if task.get('binary'):
        command += ['--binary']
    if task['mode'] == 'fixed_program':
        command += ['--fixed']
    if task.get('all_cases'):
        command += ['--all-cases']
    if task.get('wrong_output'):
        command += ['--wrong-output']
    save(BASE/'logs/active.json', dict(task=task, started_unix=time.time()))
    print(json.dumps(dict(step='start', tag=tag, seconds=task['seconds'])), flush=True)
    row = launch(command, BASE/'logs'/f'{tag}.log', task['seconds']+8, env)
    row['task'] = task
    final = next((r for r in reversed(row['records'])
                  if r.get('status') in ['PASS', 'UNSAT', 'UNKNOWN']), {})
    row['status'] = final.get('status', 'UNKNOWN' if row['limited'] or row['returncode'] < 0 else 'ERROR')
    if row['status'] == 'UNSAT':
        cnf, proof = stem.with_suffix('.cnf'), stem.with_suffix('.drat')
        log = BASE/'logs'/f'{tag}.verify.log'
        checked = launch([str(CHECKER), str(cnf), str(proof)], log, 120)
        verified = checked['returncode'] == 0 and 's VERIFIED' in log.read_text()
        row['certificate'] = dict(verified=verified, returncode=checked['returncode'],
                                  seconds=checked['seconds'], cnf_sha256=digest(cnf),
                                  proof_sha256=digest(proof), log=str(log))
        if not verified:
            row['status'] = 'UNSAT_UNCHECKED'
    if row['status'] == 'PASS':
        target = BASE/'verified'/output.name
        target.write_bytes(output.read_bytes())
        memory = target.with_name(target.stem+'_mem.s')
        translated = subprocess.run([sys.executable, '-B', str(WORKER/'src/to_mem.py'),
                                     str(target), str(memory)], capture_output=True, text=True)
        assert translated.returncode == 0, translated.stderr
        row['judges'] = []
        for file, model in [(target, 'out'), (memory, 'mem')]:
            checked = subprocess.run([sys.executable, '-B', str(PROJECT/'shared/judge.py'),
                                      str(file), '--strict', '--model', model], capture_output=True, text=True)
            log = BASE/'logs'/f'{tag}_{model}.judge'
            log.write_text(checked.stdout+checked.stderr)
            row['judges'].append(dict(path=str(file), model=model, returncode=checked.returncode,
                                      sha256=digest(file), output=checked.stdout+checked.stderr, log=str(log)))
            assert not checked.returncode and checked.stdout.startswith('PASS ')
        row['k'] = len(read(target)[0])
        if row['k'] <= 31:
            results = WORKER/'RESULTS.md'
            results.write_text(f"FOUND k={row['k']} strict out and mem PASS: {target}\n\n"+results.read_text())
    row['peak_job_rss_kib'] = max((r.get('peak_job_rss_kib', 0) for r in row['records']), default=0)
    save(BASE/'logs'/f'{tag}.json', row)
    print(json.dumps(dict(step='end', tag=tag, status=row['status'], seconds=row['seconds'])), flush=True)
    return row


def controls():
    marker = BASE/'logs/controls.json'
    if marker.exists():
        return
    source = BASE/'seeds/c8_108b52d1733c50f9.s'
    partial = BASE/'seeds/partial_data_control.s'
    # Two separate partially defined columns form a data path. Each move
    # executes under the same flag. P0 retains its input value in every case.
    partial.write_text('# n=5 model=out iset=I1\n'
                       'cmp P0, P1\ncmovl S90, P0\ncmovl S91, S90\ncmovl P0, S91\n'
                       +source.read_text())
    rows = []
    for tag, seed, wrong in [('positive32', source, False),
                             ('partial_data36', partial, False),
                             ('negative_output32', source, True)]:
        task = dict(tag=tag, seed=str(seed), seed_sha256=digest(seed), registers=read(seed)[1]-1,
                    seconds=120, mode='fixed_program', canonical=True,
                    all_cases=True, wrong_output=wrong, group='control')
        row = run_task(task)
        assert row['status'] == ('UNSAT' if wrong else 'PASS'), row
        if tag == 'partial_data36':
            candidate = next(r for r in row['records'] if r.get('step') == 'candidate')
            assert len(candidate['partial_columns']) >= 2 and len(candidate['partial_data_reads']) >= 2
        rows.append(row)
    save(marker, rows)


def report(rows, tasks, finished=False):
    data = dict(finished=finished, completed=len(rows), planned=len(tasks),
                statuses=dict(Counter(r['status'] for r in rows)),
                checked_unsat=sum(r.get('certificate', {}).get('verified', False) for r in rows),
                query_wall_seconds=round(sum(r['seconds'] for r in rows), 3),
                solver_cpu_seconds=round(sum(max((x.get('solver_cpu_seconds', 0) for x in r['records']), default=0) for r in rows), 3),
                peak_job_rss_kib=max((r['peak_job_rss_kib'] for r in rows), default=0),
                decoded_models=sum(sum(x.get('step') == 'candidate' for x in r['records']) for r in rows),
                assumptions=['G1','G2','G3','G4','A2','A4','A11'],
                source_sha256={p.name: digest(p) for p in (BASE/'src').glob('*.py')})
    save(BASE/'logs/progress.json', data)
    return data


def main():
    assert os.getpriority(os.PRIO_PROCESS, 0) == 19
    os.sched_setaffinity(0, {min(os.sched_getaffinity(0))})
    resource.setrlimit(resource.RLIMIT_AS, (2800*1024**2, 2800*1024**2))
    lock = (BASE/'logs/controller.lock').open('w')
    fcntl.flock(lock, fcntl.LOCK_EX|fcntl.LOCK_NB)
    save(BASE/'logs/controller.json', dict(pid=os.getpid(), affinity=sorted(os.sched_getaffinity(0)),
                                         nice=os.getpriority(os.PRIO_PROCESS, 0), started_unix=time.time()))
    tasks = prepare()
    controls()
    path = BASE/'logs/summary.json'
    rows = json.loads(path.read_text()) if path.exists() else []
    done = {r['task']['tag'] for r in rows}
    report(rows, tasks)
    for task in tasks:
        if task['tag'] in done:
            continue
        row = run_task(task)
        rows.append(row)
        save(path, rows)
        report(rows, tasks)
        if row['status'] in ['ERROR', 'PASS']:
            break
    report(rows, tasks, finished=len(rows) == len(tasks) or any(r['status'] == 'PASS' for r in rows))


if __name__ == '__main__':
    main()
