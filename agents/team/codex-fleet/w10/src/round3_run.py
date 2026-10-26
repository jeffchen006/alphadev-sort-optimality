#!/usr/bin/env python3
"""Run round-3 jobs serially. Launch this process at nice level 19."""
import hashlib
import json
from pathlib import Path
import resource
import subprocess
import sys
import time

HERE = Path(__file__).resolve().parents[1]
PROJECT = HERE.parents[3]
ROUND = HERE/'round3'


def run(command, logfile, timeout):
    start = time.monotonic()
    with open(logfile, 'w') as out:
        try:
            p = subprocess.run(command, stdout=out, stderr=subprocess.STDOUT,
                               timeout=timeout)
            code = p.returncode
        except subprocess.TimeoutExpired:
            code = 124
    record = dict(command=list(map(str, command)), returncode=code,
                  seconds=time.monotonic()-start, log=str(logfile))
    print(json.dumps(record), flush=True)
    return record


def canonical_control(source, target):
    from partial_validate import parse
    n, program = parse(source)
    candidates = []
    for exchange in (False, True):
        def rename(x):
            return {'P2': 'P3', 'P3': 'P2'}.get(x, x) if exchange else x
        cur = {f'P{i}': i for i in range(n)}
        g = 0
        body, data, comps, outputs = [], [], [], []
        reverse = False
        for op, a, b in program:
            b = rename(b)
            if op != 'out':
                a = rename(a)
            if op == 'out':
                outputs.append(cur[b])
            elif op == 'cmp':
                reverse = cur[a] > cur[b]
                if reverse:
                    a, b = b, a
                comps.extend((cur[a], cur[b]))
            else:
                d = n+g if op == 'mov' else cur.get(a, n+g)
                s = cur.get(b, n+g)
                data.extend((d, s))
                if reverse and op != 'mov':
                    op = {'cmovl': 'cmovg', 'cmovle': 'cmovge',
                          'cmovg': 'cmovl', 'cmovge': 'cmovle'}[op]
                cur[a] = n+g
                g += 1
            body.append(f'{op} {a}, {b}')
        stream = [x for x in data+comps+outputs if x in (2, 3)]
        if not stream or stream[0] == 2:
            candidates.append(body)
    assert candidates
    target.write_text(f'# n={n} model=out iset=I1 source=w10_sym_control\n'+
                      '\n'.join(candidates[0])+'\n')


def check_proof(tag, seconds):
    cnf, drat = Path(str(tag)+'.cnf'), Path(str(tag)+'.drat')
    record = run([str(PROJECT/'bin/drat-trim'), str(cnf), str(drat),
                  '-t', str(seconds)], ROUND/(tag.name+'.proofcheck.log'), seconds+15)
    log = Path(record['log']).read_text()
    record.update(cnf_sha256=hashlib.sha256(cnf.read_bytes()).hexdigest(),
                  proof_sha256=hashlib.sha256(drat.read_bytes()).hexdigest(),
                  verified=record['returncode'] == 0 and 's VERIFIED' in log,
                  checker_status=next((x for x in log.splitlines() if x.startswith('s ')), 'UNKNOWN'))
    (ROUND/(tag.name+'.proofcheck.json')).write_text(json.dumps(record, indent=2)+'\n')
    print(json.dumps(record), flush=True)


def main():
    resource.setrlimit(resource.RLIMIT_AS, (2800*1024**2, 2800*1024**2))
    records = []
    # Known strict-correct k=20 controls must survive all new constraints.
    for mode, old in [('partial', 'n4_k20_partial_synth'),
                      ('lattice', 'n4_k20_lattice_synth')]:
        fixed = ROUND/(old+'_canonical.s')
        canonical_control(HERE/'round2'/(old+'.s'), fixed)
        tag = ROUND/('control_'+mode)
        cmd = [sys.executable, str(HERE/'src/partial_sym.py'), '--k', '20',
               '--mode', mode, '--fixed', str(fixed), '--tag', str(tag), '--timeout', '60']
        records.append(run(cmd, str(tag)+'.runlog', 90))
        result = json.loads(Path(str(tag)+'.json').read_text())
        assert result['status'] == 'SATISFIABLE', result
        records.append(run([sys.executable, str(HERE/'src/partial_validate.py'), str(tag)+'.s'],
                           str(tag)+'.judge', 60))
        assert records[-1]['returncode'] == 0
    # The requested one-hour search has free comparison outcomes and blocks.
    tag = ROUND/'n4_k19_partial_sym_history'
    cmd = [sys.executable, str(HERE/'src/partial_sym.py'), '--k', '19',
           '--mode', 'partial', '--tag', str(tag), '--timeout', '3600']
    records.append(run(cmd, str(tag)+'.runlog', 3650))
    result = json.loads(Path(str(tag)+'.json').read_text())
    if result['status'] == 'SATISFIABLE':
        records.append(run([sys.executable, str(HERE/'src/partial_validate.py'), str(tag)+'.s'],
                           str(tag)+'.judge', 60))
    if result['status'] == 'UNSATISFIABLE':
        check_proof(tag, 1200)
    # Retry the old certificate in a new file, preserving the old timeout record.
    check_proof(HERE/'round2/n5_k31_partial_flags_blocks', 1800)
    (ROUND/'campaign.json').write_text(json.dumps(records, indent=2)+'\n')


if __name__ == '__main__':
    main()
