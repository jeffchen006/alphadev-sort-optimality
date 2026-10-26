#!/usr/bin/env python3
"""Serial, resource-limited direct-partial search campaign."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import resource
import subprocess
import sys
import time

HERE = Path(__file__).resolve().parent
WORKER = HERE.parent
PROJECT = WORKER.parents[3]


def command(cmd, name, limit):
    assert os.getpriority(os.PRIO_PROCESS, 0) == 19
    started = time.monotonic()
    before = resource.getrusage(resource.RUSAGE_CHILDREN)
    full = ['/usr/bin/time', '-v', '-o', str(HERE/(name+'.resources'))]+list(map(str, cmd))
    with (HERE/(name+'.runlog')).open('w') as out:
        try:
            p = subprocess.run(full, stdout=out, stderr=subprocess.STDOUT, timeout=limit)
            rc = p.returncode
        except subprocess.TimeoutExpired:
            rc = 124
    after = resource.getrusage(resource.RUSAGE_CHILDREN)
    record = dict(name=name, command=full, returncode=rc, nice=os.getpriority(os.PRIO_PROCESS, 0),
                  wall_seconds=time.monotonic()-started,
                  child_cpu_seconds=after.ru_utime-before.ru_utime+after.ru_stime-before.ru_stime,
                  maxrss_kib=after.ru_maxrss)
    with (HERE/'jobs.jsonl').open('a') as out:
        out.write(json.dumps(record)+'\n')
    print(json.dumps(record), flush=True)
    return record


def query(name, extra, seconds, expected=None, script='partial_shapes.py'):
    tag = HERE/name
    options = ['--proof'] if script == 'partial_shapes.py' else []
    r = command([sys.executable, HERE/script, '--tag', tag,
                 '--timeout', seconds]+options+list(extra), name, seconds+90)
    assert r['returncode'] == 0, r
    record = json.loads(tag.with_suffix('.json').read_text())
    if expected is not None:
        assert record['status'] == expected, record
    if record['status'] == 'SATISFIABLE':
        v = command([sys.executable, HERE/'audit.py', tag.with_suffix('.s')], name+'.judge', 120)
        assert v['returncode'] == 0, v
        record['validation'] = str(tag.with_suffix('.validation.json'))
    if record['status'] == 'UNSATISFIABLE':
        p = command([PROJECT/'bin/drat-trim', tag.with_suffix('.cnf'), tag.with_suffix('.drat'),
                     '-t', '30'], name+'.proofcheck', 40)
        output = (HERE/(name+'.proofcheck.runlog')).read_text()
        record['certificate_verified'] = p['returncode'] == 0 and 's VERIFIED' in output
    with (HERE/'queries.jsonl').open('a') as out:
        out.write(json.dumps(record)+'\n')
    print('DECISION', name, record['status'], flush=True)
    if record['n'] == 5 and record['k'] <= 31 and record.get('validation'):
        validation = json.loads(Path(record['validation']).read_text())
        assert len(validation['judges']) == 2 and all(x['returncode'] == 0 for x in validation['judges'])
        line = f'FOUND k={record["k"]} {tag.with_suffix(".s")} strict out+mem PASS [A15]\n'
        results = WORKER/'RESULTS.md'
        results.write_text(line+results.read_text())
    return record


def controls():
    fixture = HERE/'control5_input.s'
    padded = HERE/'control5_three_input.s'
    lines = fixture.read_text().splitlines()
    i = next(i for i, s in enumerate(lines) if s.startswith('cmp '))
    lines.insert(i+1, 'cmovl S99, P0')
    padded.write_text('\n'.join(lines)+'\n')
    query('check2_three', ['--n','2','--k','6','--c','1','--q','3','--minimum','3',
                           '--cases','weak','--fixed',str(HERE/'control2_input.s')], 10, 'SATISFIABLE')
    query('reject2_bound', ['--n','2','--k','6','--c','1','--q','2','--minimum','0',
                            '--cases','weak','--fixed',str(HERE/'control2_input.s')], 10, 'UNSATISFIABLE')
    query('n2_k5_three', ['--n','2','--k','5','--c','1','--q','3','--minimum','3',
                          '--cases','weak'], 10, 'UNSATISFIABLE')
    query('n2_k6_three', ['--n','2','--k','6','--c','1','--q','3','--minimum','3',
                          '--cases','weak','--dependency'], 10, 'SATISFIABLE')
    query('check5_two', ['--k','32','--c','9','--minimum','2','--cases','weak',
                         '--free-first','--fixed',str(fixture)], 20, 'SATISFIABLE')
    query('check5_three', ['--k','33','--c','9','--minimum','3','--cases','weak',
                           '--free-first','--fixed',str(padded)], 20, 'SATISFIABLE')
    query('reject5_bound', ['--k','33','--c','9','--q','2','--minimum','0','--cases','weak',
                            '--free-first','--fixed',str(padded)], 20, 'UNSATISFIABLE')


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('phase', choices=['controls','primary','sweep','topologies','strong','audit'])
    args = ap.parse_args()
    assert os.getpriority(os.PRIO_PROCESS, 0) == 19
    resource.setrlimit(resource.RLIMIT_AS, (2600*1024**2, 2600*1024**2))
    if args.phase == 'controls':
        controls()
    elif args.phase == 'primary':
        query('k31_c9_three_weak', ['--cases','weak','--dependency'], 180)
        query('k31_c10_three_strict', ['--c','10','--dependency'], 120)
    elif args.phase == 'sweep':
        for c in range(11, 16):
            query(f'k31_c{c}_three_strict', ['--c',str(c),'--dependency'], 30)
    elif args.phase == 'topologies':
        for topology in range(1, 8):
            query(f'k31_c9_topology{topology}', ['--topology',str(topology),'--dependency'], 30)
    elif args.phase == 'strong':
        fixture = HERE/'control5_three_live_input.s'
        original = (HERE/'control5_input.s').read_text()
        assert original.count('mov S0, P0') == 1
        fixture.write_text(original.replace('mov S0, P0', 'cmovl S0, P0\ncmovge S0, P0'))
        query('strong_check2', ['--n','2','--k','6','--c','1','--q','3',
                               '--fixed',str(HERE/'control2_input.s'),'--histories'],
              10, 'SATISFIABLE', 'strong_shapes.py')
        query('strong_check5', ['--k','33','--free-first','--fixed',str(fixture),'--histories'],
              20, 'SATISFIABLE', 'strong_shapes.py')
        for topology in range(1, 8):
            query(f'k31_c9_strong_topology{topology}',
                  ['--topology',str(topology),'--histories'], 45, script='strong_shapes.py')
    elif args.phase == 'audit':
        for suffix, options in (('transition_final', []), ('model_audit', ['--models'])):
            r = command([sys.executable, HERE/'audit.py']+options, suffix, 240)
            assert r['returncode'] == 0, r


if __name__ == '__main__':
    main()
