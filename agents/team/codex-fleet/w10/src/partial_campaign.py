#!/usr/bin/env python3
"""Serial A15 SAT experiments. Run this file under nice -n 19."""
import json
from pathlib import Path
import subprocess
import sys
import time

HERE = Path(__file__).resolve().parents[1]
OUT = HERE/'round2'


def controls():
    pairs = [(0,1), (2,3), (0,2), (1,3), (1,2)]
    for mode in ('lattice', 'partial'):
        lines = [f'# n=4 R=9 model=out iset=I1 source=w10_{mode}_control']
        for j, (a,b) in enumerate(pairs):
            lines += [f'cmp P{a}, P{b}',
                      f'{"mov" if mode == "lattice" else "cmovg"} S{j}, P{a}',
                      f'cmovg P{a}, P{b}', f'cmovg P{b}, S{j}']
        lines += [f'out {j}, P{j}' for j in range(4)]
        (OUT/f'control_{mode}.s').write_text('\n'.join(lines)+'\n')


def main():
    controls()
    experiments = [
        ('n4_k20_lattice_fixed', 4, 20, 5, 'lattice', 30,
         ['--fixed', str(OUT/'control_lattice.s')]),
        ('n4_k20_partial_fixed', 4, 20, 5, 'partial', 30,
         ['--fixed', str(OUT/'control_partial.s')]),
        ('n4_lattice_reject_partial_fixed', 4, 20, 5, 'lattice', 30,
         ['--fixed', str(OUT/'control_partial.s')]),
        ('n4_partial_reject_lattice_fixed', 4, 20, 5, 'partial', 30,
         ['--fixed', str(OUT/'control_lattice.s')]),
        ('n2_k3_partial', 2, 3, 1, 'partial', 30, []),
        ('n2_k3_lattice', 2, 3, 1, 'lattice', 30, []),
        ('n3_k10_partial', 3, 10, 3, 'partial', 120, []),
        ('n3_k10_lattice', 3, 10, 3, 'lattice', 120, []),
        ('n3_k11_partial', 3, 11, 3, 'partial', 120, []),
        ('n4_k19_lattice_b33332', 4, 19, 5, 'lattice', 120,
         ['--cases', 'strict', '--network', '01,23,02,13,12', '--blocks', '3,3,3,3,2']),
        ('n4_k19_partial_b33332_noprune', 4, 19, 5, 'partial', 120,
         ['--cases', 'strict', '--network', '01,23,02,13,12', '--blocks', '3,3,3,3,2']),
        ('n4_k19_lattice_freeblocks', 4, 19, 5, 'lattice', 180,
         ['--cases', 'strict', '--network', '01,23,02,13,12']),
        ('n4_k19_partial_freeblocks_noprune', 4, 19, 5, 'partial', 240,
         ['--cases', 'strict', '--network', '01,23,02,13,12']),
        ('n4_k19_partial_dynamic', 4, 19, 5, 'partial', 180,
         ['--cases', 'strict']),
    ]
    summary = []
    for name, n, k, c, mode, timeout, extra in experiments:
        tag = OUT/name
        cmd = [sys.executable, str(HERE/'src/partial_sat.py'), '--n', str(n),
               '--k', str(k), '--c', str(c), '--mode', mode, '--origin',
               '--proof', '--timeout', str(timeout), '--tag', str(tag)] + extra
        print(json.dumps(dict(step='start', name=name, command=cmd)), flush=True)
        start = time.monotonic()
        with open(str(tag)+'.runlog', 'w') as out:
            p = subprocess.run(cmd, stdout=out, stderr=subprocess.STDOUT)
        record = dict(name=name, returncode=p.returncode, seconds=time.monotonic()-start,
                      command=cmd)
        if tag.with_suffix('.json').exists():
            record['result'] = json.loads(tag.with_suffix('.json').read_text())
        else:
            record['result'] = dict(status='ENCODER_ERROR')
        if record['result']['status'] == 'SATISFIABLE':
            with open(str(tag)+'.judge', 'w') as out:
                p = subprocess.run([sys.executable, str(HERE/'src/partial_validate.py'),
                                    str(tag)+'.s'], stdout=out, stderr=subprocess.STDOUT)
            record['judge_returncode'] = p.returncode
        summary.append(record)
        (OUT/'campaign.json').write_text(json.dumps(summary, indent=2)+'\n')
        print(json.dumps(dict(step='done', **record)), flush=True)
        if p.returncode != 0:
            raise RuntimeError(f'experiment failed: {name}')


if __name__ == '__main__':
    main()
