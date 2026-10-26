#!/usr/bin/env python3
"""Build independent positive and negative controls. Run serially."""
import json
from pathlib import Path
import re
import sys

from independent_c2 import Encoding, sha
from certify_c2 import solve

HERE = Path(__file__).resolve().parents[1]
W10 = HERE.parent/'w10'
CONTROL = HERE/'independent/controls_v2'


def canonical(source, target):
    lines = Path(source).read_text().splitlines()
    first = next(line for line in lines if line.startswith('cmp '))
    a, b = [x.strip() for x in first[4:].split(',')]
    n = int(re.search(r'\bn=(\d+)', lines[0])[1])
    old = [a, b]+[f'P{i}' for i in range(n) if f'P{i}' not in (a, b)]
    mapping = {x: f'P{i}' for i, x in enumerate(old)}
    text = re.sub(r'\bP\d+\b', lambda m: mapping[m[0]], '\n'.join(lines))
    Path(target).write_text(text+'\n')


def build(name, n, k, c, bound, fixed=None, weak=False, lc=False):
    tag = CONTROL/name
    enc = Encoding(str(tag)+'.cnf', n, k, c, bound, lc, weak)
    if fixed:
        enc.fix_program(fixed)
    meta = enc.metadata()
    enc.f.finish()
    meta['cnf_sha256'] = sha(str(tag)+'.cnf')
    Path(str(tag)+'.json').write_text(json.dumps(meta)+'\n')
    return solve(str(tag), str(tag)+'_answer')


def main():
    controls = CONTROL
    controls.mkdir(parents=True, exist_ok=True)
    src = HERE/'programs/sort2_control.s'
    src.write_text('# n=2 model=out iset=I1 source=w11_control\n'
                   'cmp P0, P1\nmov S0, P0\ncmovg P0, P1\n'
                   'cmovg P1, S0\nout 0, P0\nout 1, P1\n')
    records = []
    records.append(build('sort2_k4', 2, 4, 1, 2, weak=True))
    records.append(build('sort2_k3', 2, 3, 1, 2, weak=True))
    for name, bound in [('control_pure', 0), ('control_one_exception', 2),
                        ('reject_nonlat_bound0', 0)]:
        source = W10/'round5'/('control_one_exception.s' if name.startswith('reject')
                              else name+'.s')
        fixed = controls/(name+'_fixed.s')
        canonical(source, fixed)
        records.append(build(name, 5, 32, 9, bound, fixed))
    (controls/'summary.json').write_text(json.dumps(records, indent=2)+'\n')


if __name__ == '__main__':
    main()
