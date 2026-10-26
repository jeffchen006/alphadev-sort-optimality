#!/usr/bin/env python3
"""One five-second pass over C2 position formulas. Never start long retries.

Keep the shared formulas, case units, hashes, logs, and checked certificates.
An incomplete solver or certificate check never closes a case.
"""
import argparse
import concurrent.futures
import datetime
import hashlib
import itertools
import json
import math
import os
from pathlib import Path
import random
import resource
import shutil
import subprocess
import threading
import time

HERE = Path(__file__).resolve().parents[1]
PROJECT = HERE.parents[3]
D2 = PROJECT / 'agents/team/d2-lattice/c2'
DEST = HERE / 'c2_short'
LOCK = threading.Lock()


def stamp():
    return datetime.datetime.now(datetime.timezone.utc).isoformat()


def sha(path):
    h = hashlib.sha256()
    with Path(path).open('rb') as f:
        for block in iter(lambda: f.read(1 << 20), b''):
            h.update(block)
    return h.hexdigest()


def save(path, obj):
    tmp = path.with_suffix(path.suffix + '.tmp')
    tmp.write_text(json.dumps(obj, indent=2) + '\n')
    tmp.replace(path)


def child_limits():
    resource.setrlimit(resource.RLIMIT_AS, (2800 << 20, 2800 << 20))


def run(command, log, timeout):
    start = time.monotonic()
    with log.open('w') as f:
        proc = subprocess.Popen(list(map(str, command)), stdout=f,
                                stderr=subprocess.STDOUT, preexec_fn=child_limits)
        try:
            code = proc.wait(timeout=timeout)
        except subprocess.TimeoutExpired:
            proc.kill()
            proc.wait()
            code = 124
    return dict(command=list(map(str, command)), returncode=code,
                wall_seconds=time.monotonic() - start, log=str(log), nice=os.nice(0))


def positions(m):
    yield m, m
    yield from ((i, m) for i in range(m))
    yield from itertools.combinations(range(m), 2)


def prepare(cs):
    (DEST / 'base').mkdir(parents=True, exist_ok=True)
    records = []
    for c in cs:
        source = D2 / f'base/base_k31_c{c}.cnf'
        meta = json.loads(source.with_suffix('.json').read_text())
        assert sha(source) == meta['cnf_sha256']
        for key, filename in [('encoder_sha256', 'threshold_sat.py'),
                              ('base_sha256', 'partial_sat.py'),
                              ('symmetry_sha256', 'partial_gap.py')]:
            assert sha(HERE / 'src' / filename) == meta[key], filename
            assert sha(D2 / 'src' / filename) == meta[key], filename
        local = DEST / 'base' / source.name
        if not local.exists():
            shutil.copyfile(source, local)
        assert sha(local) == meta['cnf_sha256']
        save(local.with_suffix('.json'), meta)
        m = 31-c
        for index, (i, j) in enumerate(positions(m)):
            units = [meta['position_choices'][0][i], meta['position_choices'][1][j]]
            records.append(dict(case=f'c{c}_{i:02}_{j:02}', index_within_c=index,
                                c=c, k=31, m=m, i=i, j=j, units=units,
                                base=str(local), base_sha256=meta['cnf_sha256'],
                                variables=meta['variables'], clauses=meta['clauses']+2))
    save(DEST / 'manifest.json', dict(created=stamp(), cases=records,
         source='Unchanged d2 copies of w10 round5 encoder; exactly two position units',
         scope='Full columns; at most two non-lattice writes; lattice comparison operands'))
    return records


def solve(case):
    folder = DEST / case['case']
    folder.mkdir(exist_ok=True)
    result = folder / 'result.json'
    if result.exists():
        previous = json.loads(result.read_text())
        if previous.get('pass_complete'):
            return previous
    cnf, proof = folder / 'formula.cnf', folder / 'proof.drat'
    with Path(case['base']).open('rb') as source, cnf.open('wb') as out:
        source.readline()
        out.write(f"p cnf {case['variables']} {case['clauses']}\n".encode())
        shutil.copyfileobj(source, out)
        out.write(''.join(f'{u} 0\n' for u in case['units']).encode())
    rec = dict(case, started=stamp(), cnf_sha256=sha(cnf), decided=False,
               solver_limit_seconds=5)
    rec['solver'] = run([PROJECT / 'bin/kissat', '--time=5', cnf, proof],
                        folder / 'solver.log', 20)
    text = (folder / 'solver.log').read_text(errors='replace')
    rec['status'] = next((s[2:].strip() for s in reversed(text.splitlines())
                          if s.startswith('s ')), 'UNKNOWN')
    if rec['solver']['returncode'] not in (10, 20):
        rec['status'] = 'UNKNOWN'
    if rec['status'] == 'UNSATISFIABLE':
        assert rec['solver']['returncode'] == 20
        rec['proof_sha256'] = sha(proof)
        save(result, rec)
        rec['checker'] = run([PROJECT / 'bin/drat-trim', cnf, proof],
                             folder / 'check.log', 300)
        rec['decided'] = (rec['checker']['returncode'] == 0 and
                          's VERIFIED' in (folder / 'check.log').read_text())
    elif rec['status'] == 'SATISFIABLE':
        model = [int(x) for line in text.splitlines() if line.startswith('v ')
                 for x in line[2:].split() if int(x)]
        positive = {x for x in model if x > 0}
        with cnf.open() as f:
            next(f)
            for line in f:
                assert any(x in positive if x > 0 else -x not in positive
                           for x in map(int, line.split()[:-1]))
        from threshold_sat import ThresholdEncoding
        enc = ThresholdEncoding(n=5, k=31, c=case['c'])
        program = folder / 'candidate.s'
        program.write_text(enc.decode(model))
        del enc
        rec['assignment_checked'] = True
        rec['judge'] = run([os.sys.executable, HERE / 'src/partial_validate.py', program],
                           folder / 'judge.log', 120)
        validation = program.with_suffix('.validation.json')
        if validation.exists():
            rec['validation'] = json.loads(validation.read_text())
            judges = rec['validation']['judges']
            rec['decided'] = len(judges) == 2 and all(
                j['returncode'] == 0 and 'PASS ' in j['output'] for j in judges)
        if rec['decided']:
            with LOCK:
                results = HERE / 'RESULTS.md'
                results.write_text(f'FOUND k=31 strict=PASS out={program} [A15, C2]\n' +
                                   results.read_text())
    else:
        # A shared base plus the two recorded units reproduces this exact CNF.
        # Keep complete formula/proof files for every UNSAT and SAT decision.
        cnf.unlink()
        proof.unlink(missing_ok=True)
    rec.update(pass_complete=True, finished=stamp())
    save(result, rec)
    return rec


def status(cases, append=False):
    records = []
    for case in cases:
        p = DEST / case['case'] / 'result.json'
        if p.exists():
            records.append(json.loads(p.read_text()))
    decided = sum(bool(r.get('decided')) for r in records)
    unknown = sum(r.get('status') == 'UNKNOWN' for r in records)
    complete = sum(bool(r.get('pass_complete')) for r in records)
    per_c = {c: dict(total=sum(r['c'] == c for r in cases),
                    completed=sum(r['c'] == c and r.get('pass_complete', False) for r in records),
                    decided=sum(r['c'] == c and r.get('decided', False) for r in records),
                    unknown=sum(r['c'] == c and r.get('status') == 'UNKNOWN' for r in records))
             for c in sorted({r['c'] for r in cases})}
    rec = dict(updated=stamp(), total=len(cases), pass_completed=complete,
               decided=decided, remaining=len(cases)-decided, unknown=unknown, per_c=per_c)
    save(DEST / 'status.json', rec)
    if append:
        with (HERE / 'RESULTS.md').open('a') as f:
            f.write(f"\nC2 SHORT STATUS {rec['updated']} [A15]: {decided} cases decided / "
                    f"{len(cases)-decided} remaining / {unknown} unknown. "
                    f"Five-second passes complete: {complete}/{len(cases)}. "
                    "Long position cases remain with d2-lattice.\n")
    print(json.dumps(rec), flush=True)


def sample_d2():
    """Freeze a reproducible random sample, then check available saved proofs."""
    dest = DEST / 'independent_lrat'
    dest.mkdir(exist_ok=True)
    population = []
    for p in sorted((D2 / 'results').glob('*.json')):
        try:
            r = json.loads(p.read_text())
        except json.JSONDecodeError:
            # The external runner writes JSON directly. Retry an active write
            # on the next poll rather than treating a partial file as a result.
            continue
        if r.get('status') == 'UNSAT' and r.get('verified'):
            population.append((p, r))
    seed = 101026
    sample = random.Random(seed).sample(population, math.ceil(len(population) / 10))
    report = dict(created=stamp(), seed=seed, sampling='Uniform without replacement; ceil(N/10)',
                  population=[p.name for p, _ in population], population_size=len(population),
                  requested_sample_size=len(sample), results=[])
    for path, r in sample:
        save(dest / (r['case']+'.source.json'), r)
        record = dict(case=r['case'], source=str(path), source_sha256=sha(path), verified=False)
        # Reuse a completed independent check only if its local artifacts and
        # the peer's exact formula and proof hashes still agree.
        cached = dest / (r['case']+'.verification.json')
        if cached.exists():
            previous = json.loads(cached.read_text())
            cnf = dest / (r['case']+'.cnf')
            local_proof = dest / (r['case']+'.lrat')
            log = Path(previous.get('checker', {}).get('log', ''))
            if (previous.get('verified') and cnf.is_file() and local_proof.is_file()
                    and log.is_file() and previous['checker']['returncode'] == 0
                    and any(x.strip() == 'c VERIFIED' for x in log.read_text().splitlines())
                    and sha(cnf) == r['cnf_sha256'] == previous.get('cnf_sha256')
                    and sha(local_proof) == r['proof_sha256'] == previous.get('proof_sha256')):
                previous.update(source=str(path), source_sha256=sha(path))
                report['results'].append(previous)
                continue
        candidates = ([Path(r['proof_file'])] if r.get('proof_file') else []) + [
            D2 / 'proofs' / (r['case']+'.lrat.zst'),
            D2 / 'proofs' / (r['case']+'.lrat'), D2 / 'tmp' / (r['case']+'.lrat')]
        proof = next((p for p in candidates if p.exists()), None)
        if proof is None:
            record['status'] = 'MISSING_CERTIFICATE'
            report['results'].append(record)
            continue
        local_proof = dest / (r['case']+'.lrat')
        if proof.suffix == '.zst':
            with local_proof.open('wb') as out:
                subprocess.run(['zstd', '-dc', str(proof)], stdout=out, check=True,
                               preexec_fn=child_limits)
        else:
            shutil.copyfile(proof, local_proof)
        assert sha(local_proof) == r['proof_sha256']
        variant = '_v2' if r.get('variant') in ('_v2', 'v2') or r['case'].startswith('v2_') else ''
        base = D2 / f"base/base_k31_c{r['c']}{variant}.cnf"
        assert sha(base) == r['base_cnf_sha256']
        meta = json.loads(base.with_suffix('.json').read_text())
        assert r['encoder_sha256'] == meta['encoder_sha256']
        cnf = dest / (r['case']+'.cnf')
        with base.open('rb') as f, cnf.open('wb') as out:
            f.readline()
            out.write(f"p cnf {meta['variables']} {meta['clauses']+len(r['units'])}\n".encode())
            shutil.copyfileobj(f, out)
            out.write(''.join(f'{u} 0\n' for u in r['units']).encode())
        assert sha(cnf) == r['cnf_sha256']
        record['checker'] = run([PROJECT / 'bin/lrat-check', cnf, local_proof],
                                dest / (r['case']+'.check.log'), 3600)
        record['verified'] = record['checker']['returncode'] == 0 and any(
            x.strip() == 'c VERIFIED' for x in Path(record['checker']['log']).read_text().splitlines())
        record.update(status='VERIFIED' if record['verified'] else 'CHECK_INCOMPLETE',
                      cnf_sha256=sha(cnf), proof_sha256=sha(local_proof))
        save(cached, record)
        report['results'].append(record)
    report['verified'] = sum(r['verified'] for r in report['results'])
    report['complete'] = bool(population) and report['verified'] == len(sample)
    save(dest / 'sample.json', report)
    print(json.dumps(report), flush=True)
    return report


def watch_sample():
    """Wait for external results. Never start a position solver."""
    last_status = 0
    while True:
        report = sample_d2()
        if report['complete']:
            with (HERE / 'RESULTS.md').open('a') as f:
                f.write(f"\nC2 INDEPENDENT SAMPLE {stamp()} [A15]: "
                        f"{report['verified']}/{report['requested_sample_size']} "
                        'selected LRAT certificates independently VERIFIED. '
                        f"The recorded population has {report['population_size']} "
                        'verified d2 UNSAT results. Seed 101026; uniform sample '
                        'without replacement; size ceil(N/10). '
                        'See `c2_short/independent_lrat/sample.json`. '
                        'This snapshot does not decide remaining cases.\n')
            return
        if time.monotonic() - last_status >= 7200:
            manifest = json.loads((DEST / 'manifest.json').read_text())
            decided = unknown = 0
            for case in manifest['cases']:
                p = D2 / 'results' / (case['case']+'.json')
                if not p.exists():
                    continue
                try:
                    r = json.loads(p.read_text())
                except json.JSONDecodeError:
                    continue
                if r.get('status') == 'UNSAT' and r.get('verified'):
                    proof = Path(r['proof_file']) if r.get('proof_file') else None
                    decided += bool(proof and proof.exists())
                unknown += r.get('status') == 'UNKNOWN'
            with (HERE / 'RESULTS.md').open('a') as f:
                f.write(f"\nC2 WATCH STATUS {stamp()} [A15]: "
                        f"{decided} cases decided / {len(manifest['cases'])-decided} "
                        f"remaining / {unknown} unknown in direct d2 V1 result files. "
                        'Split parents remain open in this count. '
                        f"Independent sample: {report['verified']}/"
                        f"{report['requested_sample_size']} verified; "
                        f"available verified population {report['population_size']}.\n")
            last_status = time.monotonic()
        time.sleep(60)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--cs', default='9,10,11,12,13,14,15')
    ap.add_argument('--jobs', type=int, default=4)
    ap.add_argument('--sample-d2', action='store_true')
    ap.add_argument('--watch-sample', action='store_true')
    args = ap.parse_args()
    assert os.nice(0) >= 19 and 1 <= args.jobs <= 4
    if args.watch_sample:
        watch_sample()
        return
    if args.sample_d2:
        sample_d2()
        return
    cases = prepare(list(map(int, args.cs.split(','))))
    status(cases, True)
    last_report = time.monotonic()
    with concurrent.futures.ThreadPoolExecutor(max_workers=args.jobs) as pool:
        todo = {pool.submit(solve, case) for case in cases}
        while todo:
            done, todo = concurrent.futures.wait(todo, timeout=30,
                return_when=concurrent.futures.FIRST_COMPLETED)
            for future in done:
                future.result()
            if time.monotonic() - last_report >= 60:
                status(cases, True)
                last_report = time.monotonic()
    status(cases, True)


if __name__ == '__main__':
    main()
