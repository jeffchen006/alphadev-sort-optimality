#!/usr/bin/env python3
"""C2 exact position formulas and persistent, certificate-checked case runner.

No search constraint is added apart from the two specified position units.
Unfinished cases are retried. A solver answer alone never closes a case.
"""
import argparse
import concurrent.futures
import datetime
import fcntl
import hashlib
import itertools
import json
import os
from pathlib import Path
import resource
import subprocess
import sys
import threading
import time

HERE = Path(__file__).resolve().parents[1]
PROJECT = HERE.parents[3]
DEST = HERE / 'c2'
BASE = HERE / 'round5/n5_k31_two_exceptions_all_shapes'
LOCK = threading.Lock()


def stamp():
    return datetime.datetime.now(datetime.timezone.utc).isoformat()


def digest(path):
    h = hashlib.sha256()
    with Path(path).open('rb') as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b''):
            h.update(chunk)
    return h.hexdigest()


def save(path, obj):
    tmp = path.with_suffix(path.suffix + '.tmp')
    tmp.write_text(json.dumps(obj, indent=2) + '\n')
    tmp.replace(path)


def prepare():
    DEST.mkdir(exist_ok=True)
    meta = json.loads(BASE.with_suffix('.built.json').read_text())
    assert digest(BASE.with_suffix('.cnf')) == meta['cnf_sha256']
    for key, name in [('encoder_sha256', 'threshold_sat.py'),
                      ('base_sha256', 'partial_sat.py'),
                      ('symmetry_sha256', 'partial_gap.py')]:
        assert digest(HERE / 'src' / name) == meta[key], name
    with BASE.with_suffix('.cnf').open('rb') as inp:
        header = inp.readline()
        assert header == f"p cnf {meta['variables']} {meta['clauses']}\n".encode()
        body = inp.read()
    cases = []
    for size in range(3):
        for slots in itertools.combinations(range(22), size):
            selected = list(slots) + [22] * (2 - size)
            units = [meta['position_choices'][i][g] for i, g in enumerate(selected)]
            index = len(cases)
            data = (f"p cnf {meta['variables']} {meta['clauses']+2}\n".encode()
                    + body + ''.join(f'{u} 0\n' for u in units).encode())
            name = 'slots_' + ('_'.join(f'{x:02}' for x in slots) if slots else 'none')
            rec = dict(index=index, name=name, slots=list(slots), units=units,
                       cnf_sha256=hashlib.sha256(data).hexdigest(),
                       owner='w10' if index <= 126 else 'd2-lattice')
            cases.append(rec)
            if index <= 126:
                folder = DEST / f'case_{index:03}'
                folder.mkdir(exist_ok=True)
                cnf = folder / 'formula.cnf'
                if cnf.exists():
                    assert digest(cnf) == rec['cnf_sha256'], cnf
                else:
                    cnf.write_bytes(data)
                save(folder / 'case.json', rec)
    manifest = dict(created=stamp(), base_cnf=str(BASE.with_suffix('.cnf')),
                    base_sha256=meta['cnf_sha256'], variables=meta['variables'],
                    base_clauses=meta['clauses'], cases=cases,
                    order='size 0, size 1, size 2; lexicographic combinations of range(22)',
                    source_hashes={k: v for k, v in meta.items() if k.endswith('_sha256')})
    save(DEST / 'manifest.json', manifest)
    return manifest


def child_limit():
    resource.setrlimit(resource.RLIMIT_AS, (2800 * 1024**2, 2800 * 1024**2))


def execute(command, log):
    start = time.monotonic()
    with log.open('w') as out:
        proc = subprocess.Popen(list(map(str, command)), stdout=out,
                                stderr=subprocess.STDOUT, preexec_fn=child_limit)
        _, status, usage = os.wait4(proc.pid, 0)
        code = os.waitstatus_to_exitcode(status)
        proc.returncode = code
    return dict(command=list(map(str, command)), returncode=code,
                started_utc=stamp(), wall_seconds=time.monotonic() - start,
                cpu_seconds=usage.ru_utime + usage.ru_stime,
                maxrss_kib=usage.ru_maxrss, log=str(log), nice=os.nice(0))


def read_status(log):
    status = 'UNKNOWN'
    with log.open(errors='replace') as f:
        for line in f:
            if line.startswith('s '):
                status = line[2:].strip()
    return status


def run_case(case, seconds):
    folder = DEST / f"case_{case['index']:03}"
    cnf = folder / 'formula.cnf'
    result_path = folder / 'result.json'
    old = json.loads(result_path.read_text()) if result_path.exists() else None
    if old and old.get('decided'):
        assert digest(cnf) == old['cnf_sha256']
        if old['status'] == 'UNSATISFIABLE':
            assert digest(folder / old['proof_file']) == old['proof_sha256']
        return old
    attempt = 1 + max([0] + [int(p.stem.split('_')[1]) for p in folder.glob('attempt_*.json')])
    prefix = folder / f'attempt_{attempt:03}'
    proof = prefix.with_suffix('.drat')
    record = dict(case=case['index'], slots=case['slots'], units=case['units'],
                  attempt=attempt, cnf_sha256=digest(cnf), decided=False,
                  status='RUNNING', limit_seconds=seconds, updated=stamp())
    save(result_path, record)
    # If a previous solver finished UNSAT, retry its checker without rerunning SAT.
    pending = old and old['status'] == 'UNSATISFIABLE' and old.get('proof_file')
    if pending:
        proof = folder / old['proof_file']
        record.update(status='UNSATISFIABLE', solver=old['solver'])
    else:
        record['solver'] = execute([PROJECT / 'bin/kissat', f'--time={seconds}',
                                    cnf, proof], prefix.with_suffix('.solver.log'))
        record['status'] = read_status(prefix.with_suffix('.solver.log'))
    if record['status'] == 'UNSATISFIABLE':
        assert record['solver']['returncode'] == 20
        record['proof_file'] = proof.name
        record['proof_sha256'] = digest(proof)
        # Persist the pending certificate before invoking the checker.
        save(result_path, record)
        record['checker'] = execute([PROJECT / 'bin/drat-trim', cnf, proof,
                                      '-t', max(3600, 4 * seconds)],
                                     prefix.with_suffix('.check.log'))
        text = prefix.with_suffix('.check.log').read_text(errors='replace')
        record['decided'] = (record['checker']['returncode'] == 0 and 's VERIFIED' in text)
        record['certificate_status'] = read_status(prefix.with_suffix('.check.log'))
    elif record['status'] == 'SATISFIABLE':
        assert record['solver']['returncode'] == 10
        model = []
        for line in prefix.with_suffix('.solver.log').read_text().splitlines():
            if line.startswith('v '):
                model += [int(x) for x in line[2:].split() if int(x)]
        yes = {x for x in model if x > 0}
        with cnf.open() as inp:
            next(inp)
            for line in inp:
                assert any(x in yes if x > 0 else -x not in yes
                           for x in map(int, line.split()[:-1]))
        from threshold_sat import ThresholdEncoding
        enc = ThresholdEncoding()
        program = prefix.with_suffix('.s')
        program.write_text(enc.decode(model))
        del enc
        record['assignment_checked'] = True
        record['judge'] = execute([sys.executable, HERE / 'src/partial_validate.py', program],
                                  prefix.with_suffix('.judge.log'))
        validation = json.loads(program.with_suffix('.validation.json').read_text())
        record['decided'] = (record['judge']['returncode'] == 0 and
                             len(validation['judges']) == 2 and
                             all(j['returncode'] == 0 and 'PASS ' in j['output']
                                 for j in validation['judges']))
        record['validation'] = validation
        if record['decided']:
            line = f'FOUND k=31 strict=PASS out={program} [A15, C2]\n'
            with LOCK:
                results = HERE / 'RESULTS.md'
                results.write_text(line + results.read_text())
            (DEST / 'FOUND').write_text(line)
    else:
        # An incomplete proof certifies no decision. Do not retain large fragments.
        if proof.exists():
            record['incomplete_proof_bytes'] = proof.stat().st_size
            proof.unlink()
    record['updated'] = stamp()
    save(prefix.with_suffix('.json'), record)
    save(result_path, record)
    print(json.dumps({k: record.get(k) for k in ('case', 'attempt', 'status', 'decided', 'updated')}), flush=True)
    return record


def report(manifest, append=False):
    records = []
    for case in manifest['cases'][:127]:
        p = DEST / f"case_{case['index']:03}/result.json"
        if p.exists():
            records.append(json.loads(p.read_text()))
    decided = sum(bool(r.get('decided')) for r in records)
    unknown = sum(r['status'] == 'UNKNOWN' for r in records)
    active = sum(r['status'] == 'RUNNING' for r in records)
    s = dict(updated=stamp(), assigned=127, decided=decided, remaining=127-decided,
             unknown=unknown, active=active,
             checked_unsat=sum(r['status'] == 'UNSATISFIABLE' and r['decided'] for r in records),
             pending_certificate=sum(r['status'] == 'UNSATISFIABLE' and not r['decided'] for r in records),
             cases=[{k: r.get(k) for k in ('case', 'status', 'decided', 'attempt')} for r in records])
    save(DEST / 'status.json', s)
    if append:
        line = (f"\nC2 STATUS {s['updated']} [A15]: {decided} cases decided / "
                f"{127-decided} remaining / {unknown} unknown; {active} running; "
                f"{s['pending_certificate']} certificates pending. Assigned cases 0..126.\n")
        with (HERE / 'RESULTS.md').open('a') as out:
            out.write(line)
        print(line.strip(), flush=True)
    return s


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--prepare', action='store_true')
    ap.add_argument('--jobs', type=int, default=4)
    ap.add_argument('--first-seconds', type=int, default=120)
    args = ap.parse_args()
    assert 1 <= args.jobs <= 4
    assert os.nice(0) >= 19
    DEST.mkdir(exist_ok=True)
    with (DEST / 'runner.lock').open('w') as lock:
        fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        manifest = prepare()
        if args.prepare:
            print(json.dumps(dict(cases=len(manifest['cases']), saved_formulas=127)))
            return
        last_report = 0
        seconds = args.first_seconds
        while not (DEST / 'FOUND').exists():
            pending = []
            for case in manifest['cases'][:127]:
                p = DEST / f"case_{case['index']:03}/result.json"
                if not p.exists() or not json.loads(p.read_text()).get('decided'):
                    pending.append(case)
            if not pending:
                report(manifest, True)
                return
            print(json.dumps(dict(round_seconds=seconds, pending=len(pending))), flush=True)
            with concurrent.futures.ThreadPoolExecutor(max_workers=args.jobs) as pool:
                futures = {pool.submit(run_case, case, seconds): case for case in pending}
                while futures:
                    done, _ = concurrent.futures.wait(futures, timeout=30,
                                          return_when=concurrent.futures.FIRST_COMPLETED)
                    for future in done:
                        future.result()
                        del futures[future]
                    now = time.monotonic()
                    report(manifest, now-last_report >= 7200)
                    if now-last_report >= 7200:
                        last_report = now
            seconds *= 4


if __name__ == '__main__':
    main()
