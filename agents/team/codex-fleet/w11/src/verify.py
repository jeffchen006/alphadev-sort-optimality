#!/usr/bin/env python3
"""Independent parser, weak-order simulation, lattice test, and judge calls."""
import argparse
import itertools
import json
from pathlib import Path
import re
import subprocess
import sys

PROJECT = Path('/path/to/repo')


def read_program(path):
    text = Path(path).read_text()
    match = re.search(r'\bn=(\d+)', text)
    n = int(match.group(1)) if match else 5
    code = []
    for line in text.splitlines():
        line = line.partition('#')[0].strip()
        if not line:
            continue
        op, tail = line.split(None, 1)
        a, b = [s.strip() for s in tail.split(',')]
        assert op in ('mov', 'cmp', 'cmovl', 'cmovle', 'cmovg', 'cmovge', 'out')
        code.append((op, a, b))
    return n, code


def lattice(column, orders, n):
    table = {0: False, (1 << n)-1: True}
    for order, value in zip(orders, column):
        if value is None:
            return False
        for t in range(1, max(order)+1):
            mask = sum(1 << i for i, x in enumerate(order) if x >= t)
            bit = value >= t
            if mask in table and table[mask] != bit:
                return False
            table[mask] = bit
    return all(not a_val or b_val for a, a_val in table.items()
               for b, b_val in table.items() if a & b == a)


def simulate(n, code):
    orders = [o for o in itertools.product(range(n), repeat=n)
              if set(o) == set(range(max(o)+1))]
    columns = [[] for op, a, b in code if op not in ('cmp', 'out')]
    cmpcolumns = []
    errors = 0
    undefined = 0
    for order in orders:
        regs = {f'P{i}': x for i, x in enumerate(order)}
        outs = {}
        flag = None
        g = j = 0
        for op, a, b in code:
            if op == 'out':
                outs[int(a)] = regs.get(b)
            elif op == 'cmp':
                av, bv = regs.get(a), regs.get(b)
                if av is None or bv is None:
                    raise ValueError('Comparison reads undefined data')
                if j == len(cmpcolumns):
                    cmpcolumns.append([[], []])
                cmpcolumns[j][0].append(av)
                cmpcolumns[j][1].append(bv)
                flag = (av > bv) - (av < bv)
                j += 1
            else:
                if op == 'mov':
                    regs[a] = regs.get(b)
                else:
                    if flag is None:
                        raise ValueError('Conditional write precedes first comparison')
                    take = {'cmovl': flag < 0, 'cmovle': flag <= 0,
                            'cmovg': flag > 0, 'cmovge': flag >= 0}[op]
                    if take:
                        regs[a] = regs.get(b)
                columns[g].append(regs.get(a))
                undefined += regs.get(a) is None
                g += 1
        errors += sum(outs.get(i, regs.get(f'P{i}')) != v
                      for i, v in enumerate(sorted(order)))
    return dict(weak_orders=len(orders), wrong_outputs=errors,
                undefined_written_entries=undefined,
                nonlattice_written_versions=[g for g, col in enumerate(columns)
                    if not lattice(col, orders, n)],
                nonlattice_comparison_operands=[(j, s) for j, row in enumerate(cmpcolumns)
                    for s, col in enumerate(row) if not lattice(col, orders, n)],
                k=sum(op != 'out' for op, a, b in code),
                c=sum(op == 'cmp' for op, a, b in code))


def validate(path):
    path = Path(path)
    n, code = read_program(path)
    rec = dict(file=str(path), **simulate(n, code))
    registers = sorted({x for op, a, b in code for x in
                        ((b,) if op == 'out' else (a, b))})
    rename = {r: f'S{i}' for i, r in enumerate(registers)}
    body = [f'# n={n} model=mem iset=I1 source=w11_translation']
    body += [f'mov {rename[f"P{i}"]}, P{i}' for i in range(n)]
    body += [f'mov P{a}, {rename[b]}' if op == 'out'
             else f'{op} {rename[a]}, {rename[b]}' for op, a, b in code]
    mem = path.with_name(path.stem+'_mem.s')
    mem.write_text('\n'.join(body)+'\n')
    rec['judges'] = []
    for candidate, model in ((path, 'out'), (mem, 'mem')):
        cmd = [sys.executable, str(PROJECT/'shared/judge.py'), str(candidate),
               '--strict', '--model', model]
        proc = subprocess.run(cmd, text=True, capture_output=True)
        rec['judges'].append(dict(file=str(candidate), model=model,
            returncode=proc.returncode, output=proc.stdout+proc.stderr))
        print(proc.stdout+proc.stderr, end='', flush=True)
    path.with_suffix('.validation.json').write_text(json.dumps(rec, indent=2)+'\n')
    assert rec['wrong_outputs'] == rec['undefined_written_entries'] == 0, rec
    assert all(j['returncode'] == 0 and 'PASS' in j['output'] for j in rec['judges']), rec
    print(json.dumps({k:v for k,v in rec.items() if k != 'judges'}), flush=True)
    return rec


if __name__ == '__main__':
    ap = argparse.ArgumentParser()
    ap.add_argument('file')
    args = ap.parse_args()
    validate(args.file)
