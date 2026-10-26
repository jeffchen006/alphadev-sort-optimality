#!/usr/bin/env python3
"""Serial A15 threshold SAT campaign. Start with nice -n 19."""
import collections
import hashlib
import itertools
import json
import os
from pathlib import Path
import resource
import shutil
import subprocess
import sys
import time

HERE = Path(__file__).resolve().parents[1]
PROJECT = HERE.parents[3]
ROUND = HERE/'round5'


def digest(path):
    h = hashlib.sha256()
    with Path(path).open('rb') as f:
        for part in iter(lambda: f.read(1024*1024), b''):
            h.update(part)
    return h.hexdigest()


def run(cmd, name, timeout):
    assert os.getpriority(os.PRIO_PROCESS, 0) >= 19
    start = time.monotonic()
    before = resource.getrusage(resource.RUSAGE_CHILDREN)
    log = ROUND/(name+'.runlog')
    with log.open('w') as out:
        try:
            p = subprocess.run(list(map(str, cmd)), stdout=out, stderr=subprocess.STDOUT,
                               timeout=timeout)
            code = p.returncode
        except subprocess.TimeoutExpired:
            code = 124
    after = resource.getrusage(resource.RUSAGE_CHILDREN)
    record = dict(command=list(map(str, cmd)), returncode=code, log=str(log),
                  wall_seconds=time.monotonic()-start,
                  child_cpu_seconds=after.ru_utime-before.ru_utime+after.ru_stime-before.ru_stime,
                  maxrss_kib=after.ru_maxrss, nice=os.getpriority(os.PRIO_PROCESS, 0))
    with (ROUND/'campaign.jsonl').open('a') as out:
        out.write(json.dumps(record)+'\n')
    print(json.dumps(record), flush=True)
    return record


def save(s):
    (ROUND/'summary.json').write_text(json.dumps(s, indent=2)+'\n')
    part = collections.Counter(q['status'] for q in s['partitions'])
    lines = ['<!-- ROUND5_BEGIN -->', '## Round 5: two full non-lattice values [A15]', '',
             'The threshold SAT formula leaves every lattice shape free. A lattice shape',
             'is a monotone Boolean table on all 32 input subsets. No network term pool',
             'or fixed comparison outcome family is imposed. The method and limits are',
             'in `round5/METHOD.md`. A time limit means UNKNOWN.', '',
             '| query | n | k | solver result | correct-program count |',
             '|---|---:|---:|---|---:|']
    passes, found = [], []
    for q in s['queries']:
        lines.append(f"| {Path(q['tag']).name} | {q['n']} | {q['k']} | {q['status']} | "
                     f"{0 if q['status'] == 'UNSATISFIABLE' else 'unknown'} |")
        vpath = Path(q['tag']+'.validation.json')
        if vpath.exists():
            v = json.loads(vpath.read_text())
            if len(v['judges']) == 2 and all(j['returncode'] == 0 and 'PASS ' in j['output'] for j in v['judges']):
                files = [str(Path(j['file']).relative_to(HERE)) for j in v['judges']]
                passes.append((q['n'], q['k'], files))
                if q['n'] == 5 and q['k'] <= 31:
                    found.append(f"FOUND k={q['k']} n=5 out={files[0]} mem={files[1]} strict=PASS [A15]")
    lines += ['', f"Position cases completed: {len(s['partitions'])}/254.",
              'Position case decisions: '+', '.join(f'{k}={v}' for k,v in sorted(part.items()))+'.',
              'Every UNSAT case has exhaustive count zero in its saved formula.',
              'Every UNKNOWN case has unknown count. Counts are not added across',
              'overlapping program classes.', '', 'New strict judge PASS files:', '']
    lines += [f'- n={n}, k={k}: `{p[0]}` and `{p[1]}`.' for n,k,p in passes]
    lines += ['', f"Certificate checks accepted: {sum(p['verified'] for p in s['certificates'])}/{len(s['certificates'])}.",
              f"Campaign complete: {s.get('complete', False)}.",
              'The general A15 claim remains open. No assumption is marked CHALLENGED.',
              '<!-- ROUND5_END -->']
    path = HERE/'RESULTS.md'
    text = path.read_text()
    begin, end = '<!-- ROUND5_BEGIN -->', '<!-- ROUND5_END -->'
    if begin in text:
        a, b = text.index(begin), text.index(end)+len(end)
        text = text[:a]+'\n'.join(lines)+text[b:]
    else:
        text += '\n'+'\n'.join(lines)+'\n'
    for line in reversed(found):
        if line not in text:
            text = line+'\n'+text
    temp = HERE/'RESULTS.round5.tmp'
    temp.write_text(text)
    temp.replace(path)


def check_proof(s, name, cnf, proof, seconds=30):
    r = run([PROJECT/'bin/drat-trim', cnf, proof, '-t', seconds], name+'.proofcheck', seconds+5)
    output = Path(r['log']).read_text()
    r.update(verified=r['returncode'] == 0 and 's VERIFIED' in output,
             checker_status=next((x for x in output.splitlines() if x.startswith('s ')), 'UNKNOWN'),
             cnf_sha256=digest(cnf), proof_sha256=digest(proof))
    s['certificates'].append(r)
    save(s)


def query(s, name, extra, seconds, expected=None, script='threshold_sat.py'):
    tag = ROUND/name
    r = run([sys.executable, HERE/'src'/script, '--tag', tag, '--timeout', seconds,
             '--proof']+extra, name, seconds+60)
    assert r['returncode'] == 0, r
    q = json.loads(Path(str(tag)+'.json').read_text())
    if expected:
        assert q['status'] == expected, q
    if q['status'] == 'SATISFIABLE':
        v = run([sys.executable, HERE/'src/partial_validate.py', str(tag)+'.s'], name+'.judge', 90)
        q['validation_returncode'] = v['returncode']
    s['queries'].append(q)
    save(s)
    if q['status'] == 'SATISFIABLE':
        assert q['validation_returncode'] == 0, 'Strict judge failed; refine on weak orders'
    if q['status'] == 'UNSATISFIABLE':
        check_proof(s, name, Path(str(tag)+'.cnf'), Path(str(tag)+'.drat'))
    return q


def partition(s, base, positions, seconds=5):
    m = base['k']-base['c']
    selected = list(positions)+[m]*(2-len(positions))
    units = [base['position_choices'][i][g] for i, g in enumerate(selected)]
    name = 'slots_'+('_'.join(f'{x:02}' for x in positions) if positions else 'none')
    tag = ROUND/name
    cnf, proof = Path(str(tag)+'.cnf'), Path(str(tag)+'.drat')
    source = Path(base['tag']+'.cnf')
    with source.open('rb') as inp, cnf.open('wb') as out:
        inp.readline()
        out.write(f"p cnf {base['variables']} {base['clauses']+len(units)}\n".encode())
        shutil.copyfileobj(inp, out)
        for u in units:
            out.write(f'{u} 0\n'.encode())
    r = run([PROJECT/'bin/kissat', '--time='+str(seconds), cnf, proof], name, seconds+5)
    status, model = 'UNKNOWN', []
    for line in Path(r['log']).read_text().splitlines():
        if line.startswith('s '):
            status = line[2:].strip()
        if line.startswith('v '):
            model += [int(x) for x in line[2:].split() if int(x)]
    q = dict(name=name, slots=list(positions), units=units,
             base_cnf=base['tag']+'.cnf', base_sha256=base['cnf_sha256'],
             cnf_sha256=digest(cnf), status=status, limit_seconds=seconds,
             exhaustive_program_count=0 if status == 'UNSATISFIABLE' else None,
             run=r, proof_sha256=digest(proof) if proof.exists() else None)
    # Save only the shared CNF and these unit clauses. Exact CNF is reproducible.
    if status == 'SATISFIABLE':
        from threshold_sat import ThresholdEncoding
        enc = ThresholdEncoding()
        assert enc.nv == base['variables'] and len(enc.cs) == base['clauses']
        yes = {x for x in model if x > 0}
        assert all(any((x in yes) if x > 0 else (-x not in yes) for x in cl) for cl in enc.cs)
        assert all(u in yes for u in units)
        Path(str(tag)+'.s').write_text(enc.decode(model))
        del enc
        v = run([sys.executable, HERE/'src/partial_validate.py', str(tag)+'.s'], name+'.judge', 90)
        assert v['returncode'] == 0, 'Strict judge failed; refine on weak orders'
        q.update(tag=str(tag), n=5, k=31, assignment_checked=True)
        s['queries'].append(q)
    s['partitions'].append(q)
    Path(str(tag)+'.json').write_text(json.dumps(q, indent=2)+'\n')
    save(s)
    if status == 'UNSATISFIABLE':
        check_proof(s, name, cnf, proof, seconds=15)
    if status != 'SATISFIABLE':
        cnf.unlink()
    if proof.exists() and status == 'UNKNOWN':
        proof.unlink()


def main():
    resource.setrlimit(resource.RLIMIT_AS, (2800*1024**2, 2800*1024**2))
    assert os.getpriority(os.PRIO_PROCESS, 0) >= 19
    ROUND.mkdir(exist_ok=True)
    assert not (ROUND/'summary.json').exists(), 'Use a new round or resume explicitly'
    s = dict(queries=[], partitions=[], certificates=[], complete=False)
    save(s)
    query(s, 'control_one_exception', ['--k', '32', '--free-first', '--fixed',
          HERE/'programs/exception_0_eliminated.s'], 60, 'SATISFIABLE')
    query(s, 'control_pure', ['--k', '32', '--slots', '', '--free-first', '--fixed',
          HERE/'programs/exception_0_normalized.s'], 60, 'SATISFIABLE')
    query(s, 'reject_nonlat_bound0', ['--k', '32', '--slots', '', '--free-first', '--fixed',
          HERE/'programs/exception_0_eliminated.s'], 60, 'UNSATISFIABLE')
    query(s, 'n2_k4_control', ['--n', '2', '--k', '4', '--c', '1', '--slots', '', '--cases', 'weak'],
          60, 'SATISFIABLE')
    query(s, 'n2_k3_reject', ['--n', '2', '--k', '3', '--c', '1', '--slots', '', '--cases', 'weak'],
          60, 'UNSATISFIABLE')
    base = query(s, 'n5_k31_two_exceptions_all_shapes', [], 1200)
    for size in range(3):
        for slots in itertools.combinations(range(22), size):
            partition(s, base, slots)
    s['complete'] = True
    save(s)
    print(json.dumps(dict(complete=True, partitions=collections.Counter(q['status'] for q in s['partitions']))), flush=True)


if __name__ == '__main__':
    main()
