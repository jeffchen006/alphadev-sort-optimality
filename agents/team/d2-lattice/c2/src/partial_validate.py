#!/usr/bin/env python3
"""Independent concrete checks and strict judge for small-n SAT candidates."""
import argparse
import itertools
import json
from pathlib import Path
import re
import subprocess
import sys

PROJECT = Path('/path/to/repo')


def parse(path):
    text = path.read_text()
    n = int(re.search(r'\bn=(\d+)', text).group(1))
    program = []
    for line in text.splitlines():
        line = line.split('#')[0].strip()
        if line:
            op, rest = line.split(None, 1)
            a, b = [s.strip() for s in rest.split(',')]
            program.append((op, a, b))
    return n, program


def analyze(n, program):
    types = [p for p in itertools.product(range(n), repeat=n)
             if set(p) == set(range(max(p)+1))]
    writes = [i for i, (op, a, b) in enumerate(program) if op not in ('cmp', 'out')]
    columns = [[] for _ in writes]
    errors, bad_cmp = 0, 0
    for ty in types:
        regs = {f'P{i}': x for i, x in enumerate(ty)}
        outs = {}
        fl = None
        g = 0
        for op, a, b in program:
            if op == 'out':
                outs[int(a)] = regs.get(b)
            elif op == 'cmp':
                u, v = regs.get(a), regs.get(b)
                if u is None or v is None:
                    bad_cmp += 1
                    fl = None
                else:
                    fl = (u > v) - (u < v)
            else:
                if op == 'mov':
                    regs[a] = regs.get(b)
                elif fl is None:
                    # This encoder has no data instructions before first cmp.
                    raise ValueError('undefined flags')
                else:
                    take = {'cmovl': fl < 0, 'cmovle': fl <= 0,
                            'cmovg': fl > 0, 'cmovge': fl >= 0}[op]
                    if take:
                        regs[a] = regs.get(b)
                columns[g].append(regs.get(a))
                g += 1
        errors += sum(outs.get(j, regs.get(f'P{j}')) != value
                      for j, value in enumerate(sorted(ty)))
    partial, nonlattice, full_lattice = [], [], []
    for g, column in enumerate(columns):
        if None in column:
            partial.append(g)
            continue
        truth = {0: False, (1 << n)-1: True}
        okay = True
        for ty, value in zip(types, column):
            for threshold in range(1, max(ty)+1):
                mask = sum(1 << i for i, x in enumerate(ty) if x >= threshold)
                result = value >= threshold
                if mask in truth and truth[mask] != result:
                    okay = False
                truth[mask] = result
        for a, va in truth.items():
            for b, vb in truth.items():
                if a & b == a and va and not vb:
                    okay = False
        (full_lattice if okay else nonlattice).append(g)
    return dict(n=n, weak_orders=len(types), wrong_outputs=errors,
                undefined_comparisons=bad_cmp, partial_data_nodes=partial,
                nonlattice_full_data_nodes=nonlattice,
                lattice_full_data_nodes=full_lattice,
                k=sum(op != 'out' for op, a, b in program),
                comparisons=sum(op == 'cmp' for op, a, b in program))


def memory(n, program, path):
    names = {r for op, a, b in program for r in ((b,) if op == 'out' else (a, b))}
    rename = {r: f'S{i}' for i, r in enumerate(sorted(names))}
    lines = [f'# n={n} model=mem iset=I1 source=w10_partial_sat_translation']
    lines += [f'mov {rename[f"P{i}"]}, P{i}' for i in range(n)]
    for op, a, b in program:
        lines.append(f'mov P{a}, {rename[b]}' if op == 'out'
                     else f'{op} {rename[a]}, {rename[b]}')
    target = path.with_name(path.stem + '_mem.s')
    target.write_text('\n'.join(lines) + '\n')
    return target


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('file')
    args = ap.parse_args()
    path = Path(args.file)
    n, program = parse(path)
    result = analyze(n, program)
    result['judges'] = []
    for f, model in ((path, 'out'), (memory(n, program, path), 'mem')):
        cmd = [sys.executable, str(PROJECT/'shared/judge.py'), str(f), '--strict', '--model', model]
        p = subprocess.run(cmd, capture_output=True, text=True)
        record = dict(file=str(f), model=model, returncode=p.returncode,
                      output=p.stdout + p.stderr)
        result['judges'].append(record)
        print(record['output'], end='', flush=True)
    path.with_suffix('.validation.json').write_text(json.dumps(result, indent=2) + '\n')
    print(json.dumps({k: v for k, v in result.items() if k != 'judges'}), flush=True)
    assert result['wrong_outputs'] == result['undefined_comparisons'] == 0
    assert all(x['returncode'] == 0 and 'PASS' in x['output'] for x in result['judges'])


if __name__ == '__main__':
    main()
