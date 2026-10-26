#!/usr/bin/env python3
"""Independent scalar trace, lattice test, transition audit, and strict judges."""
import argparse
import hashlib
import itertools
import json
import os
from pathlib import Path
import resource
import subprocess
import sys

from pysat.solvers import Minisat22
from partial_shapes import PartialShapes, PROJECT


def orders(n):
    return [p for p in itertools.product(range(n), repeat=n)
            if set(p) == set(range(max(p)+1))]


def parse(text):
    ans = []
    for line in text.splitlines():
        line = line.partition('#')[0].strip()
        if line:
            op, operands = line.split(None, 1)
            a, b = map(str.strip, operands.split(','))
            ans.append((op, a, b))
    return ans


def trace(n, program, cases=None):
    cases = cases or orders(n)
    nw = sum(op not in ('cmp', 'out') for op, a, b in program)
    columns = [[] for _ in range(nw)]
    flags = [[] for _ in range(sum(op == 'cmp' for op, a, b in program))]
    wrong, badcmp = 0, 0
    for case in cases:
        regs = {f'P{i}': x for i, x in enumerate(case)}
        outs, f, g, j = {}, None, 0, 0
        for op, a, b in program:
            if op == 'out':
                outs[int(a)] = regs.get(b)
            elif op == 'cmp':
                av, bv = regs.get(a), regs.get(b)
                if av is None or bv is None:
                    badcmp += 1
                    f = None
                else:
                    f = (av > bv)-(av < bv)
                flags[j].append(f)
                j += 1
            else:
                if op == 'mov':
                    take = True
                else:
                    assert f is not None
                    take = {'cmovl': f < 0, 'cmovle': f <= 0,
                            'cmovg': f > 0, 'cmovge': f >= 0}[op]
                if take:
                    regs[a] = regs.get(b)
                columns[g].append(regs.get(a))
                g += 1
        wrong += sum(outs.get(j, regs.get(f'P{j}')) != x
                     for j, x in enumerate(sorted(case)))
    partial, nonlattice = [], []
    for g, col in enumerate(columns):
        if None in col:
            partial.append(g)
            continue
        truth = {0: False, (1 << n)-1: True}
        okay = True
        for case, value in zip(cases, col):
            for rank in range(1, max(case)+1):
                mask = sum(1 << i for i, x in enumerate(case) if x >= rank)
                bit = value >= rank
                if mask in truth and truth[mask] != bit:
                    okay = False
                truth[mask] = bit
        if any(av and not bv and a & b == a
               for a, av in truth.items() for b, bv in truth.items()):
            okay = False
        if not okay:
            nonlattice.append(g)
    return dict(columns=columns, flags=flags, partial=partial, nonlattice=nonlattice,
                wrong=wrong, badcmp=badcmp, cases=len(cases))


def transition_audit():
    ops = ('cmovl', 'cmovle', 'cmovg', 'cmovge')
    programs = []
    for a, b, c in itertools.product(ops, repeat=3):
        programs.append(f'cmp P0, P1\n{a} S0, P0\n{b} S1, S0\n{c} S1, P1\n')
    for a, b in itertools.product(ops, repeat=2):
        programs.append(f'cmp P0, P1\n{a} P0, S0\nmov S1, P0\n{b} P0, P1\n')
    # These cases compare equal copies even on distinct inputs.
    for a, b in itertools.product(ops, repeat=2):
        programs.append(f'cmp P0, P1\nmov S0, P0\ncmp P0, S0\n{a} S1, P1\n{b} P0, S1\n')
    checks = 0
    signatures = []
    for text in programs:
        program = parse(text)
        t = trace(2, program)
        assert not t['nonlattice'] and not t['badcmp']
        c = sum(op == 'cmp' for op, a, b in program)
        k = sum(op != 'out' for op, a, b in program)
        enc = PartialShapes(2, k, c, len(t['partial']), orders(2), len(t['partial']),
                            slots=t['partial'], symmetry=False, output_requirements=False)
        enc.fix_program(text)
        with Minisat22(bootstrap_with=enc.cs) as solver:
            assert solver.solve(), text
            for g, col in enumerate(t['columns']):
                if g in t['partial']:
                    e = t['partial'].index(g)
                    for ti, value in enumerate(col):
                        df = enc.defined[e][ti]
                        assert not solver.solve(assumptions=[df if value is None else -df])
                        checks += 1
                        if value is not None:
                            for r, bit in enumerate(enc.rows[e][ti], 1):
                                assert not solver.solve(assumptions=[-bit if value >= r else bit])
                                checks += 1
                else:
                    for ti, value in enumerate(col):
                        for r, mask in enumerate(enc.masks[ti], 1):
                            bit = enc.truth[2+g][mask]
                            assert not isinstance(bit, bool)
                            assert not solver.solve(assumptions=[-bit if value >= r else bit])
                            checks += 1
            signatures.append(hashlib.sha256(json.dumps(t['columns']).encode()).hexdigest())
    return dict(programs=len(programs), opposite_value_probes=checks,
                trace_sha256=hashlib.sha256(json.dumps(signatures).encode()).hexdigest(),
                result='all independent scalar values and undefined bits agree')


def validate(path):
    text = path.read_text()
    import re
    n = int(re.search(r'\bn=(\d+)', text).group(1))
    program = parse(text)
    audit = trace(n, program)
    assert audit['wrong'] == audit['badcmp'] == 0, audit
    names = sorted({r for op, a, b in program for r in ((b,) if op == 'out' else (a, b))})
    rename = {r: f'S{i}' for i, r in enumerate(names)}
    memory = path.with_name(path.stem+'_mem.s')
    lines = [f'# n={n} model=mem iset=I1 source=w1_partial_shapes']
    lines += [f'mov {rename[f"P{i}"]}, P{i}' for i in range(n)]
    lines += [f'mov P{a}, {rename[b]}' if op == 'out' else f'{op} {rename[a]}, {rename[b]}'
              for op, a, b in program]
    memory.write_text('\n'.join(lines)+'\n')
    judges = []
    for file, model in ((path, 'out'), (memory, 'mem')):
        cmd = [sys.executable, str(PROJECT/'shared/judge.py'), str(file), '--strict', '--model', model]
        p = subprocess.run(cmd, capture_output=True, text=True)
        judges.append(dict(file=str(file), command=cmd, returncode=p.returncode,
                           sha256=hashlib.sha256(file.read_bytes()).hexdigest(),
                           output=p.stdout+p.stderr))
        print(p.stdout+p.stderr, end='', flush=True)
        assert p.returncode == 0 and 'PASS ' in p.stdout, judges[-1]
    record = {key: value for key, value in audit.items() if key not in ('columns', 'flags')}
    record.update(judges=judges, k=sum(op != 'out' for op, a, b in program), n=n)
    path.with_suffix('.validation.json').write_text(json.dumps(record, indent=2)+'\n')
    return record


def model_audit():
    from strong_shapes import strengthen
    records = []
    allqueries = [json.loads(line) for line in Path(__file__).with_name('queries.jsonl').read_text().splitlines()]
    for query in allqueries:
        if query['status'] != 'SATISFIABLE':
            continue
        args = query['args']
        n = query['n']
        cases = orders(n) if args.get('cases', 'weak') == 'weak' else list(itertools.permutations(range(n)))
        strong = 'strong_source_sha256' in query
        slots = args.get('slots')
        slots = None if slots is None else tuple(int(x) for x in slots.split(',') if x)
        enc = PartialShapes(n, query['k'], query['c'], query['q'], cases,
                            args.get('minimum', query['q']),
                            first_pair=not args.get('free_first', False),
                            symmetry=not args.get('fixed') and not args.get('no_symmetry', False),
                            slots=slots, dependency=True if strong else args.get('dependency', False),
                            topology=args.get('topology'))
        if strong:
            strengthen(enc, **{key: query['strengthening'][key]
                              for key in ('mixed', 'useful', 'live', 'histories')})
        if args.get('fixed'):
            enc.fix_program(Path(args['fixed']).read_text())
        assert enc.nv == query['variables'] and len(enc.cs) == query['clauses']
        model = []
        for line in Path(query['tag']+'.solver').read_text().splitlines():
            if line.startswith('v '):
                model += [int(x) for x in line[2:].split() if int(x)]
        yes = {x for x in model if x > 0}
        true = lambda x: x if isinstance(x, bool) else x in yes
        selected = [next(i for i, x in enumerate(row) if x in yes) for row in enc.positions]
        partials = {g: e for e, g in enumerate(selected) if g < enc.m}
        decoded = Path(query['tag']+'.s')
        scalar = trace(n, parse(decoded.read_text()), cases)
        values = 0
        for g, col in enumerate(scalar['columns']):
            for t, expected in enumerate(col):
                if g in partials:
                    e = partials[g]
                    defined = true(enc.defined[e][t])
                    actual = sum(true(x) for x in enc.rows[e][t]) if defined else None
                else:
                    actual = sum(true(enc.truth[n+g][mask]) for mask in enc.masks[t])
                assert actual == expected, (query['tag'], g, t, actual, expected)
                values += 1
        comparisons = 0
        for j, column in enumerate(scalar['flags']):
            for t, expected in enumerate(column):
                actual = [f-1 for f in range(3) if true(enc.fl[j][t][f])]
                assert actual == [expected], (query['tag'], j, t, actual, expected)
                comparisons += 1
        records.append(dict(tag=query['tag'], values_checked=values, comparisons_checked=comparisons,
                            result='all decoded intermediate values and flags agree'))
    result = dict(programs=len(records), values_checked=sum(x['values_checked'] for x in records),
                  comparisons_checked=sum(x['comparisons_checked'] for x in records), records=records)
    Path(__file__).with_name('model_audit.json').write_text(json.dumps(result, indent=2)+'\n')
    return result


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('file', nargs='?', type=Path)
    ap.add_argument('--models', action='store_true')
    args = ap.parse_args()
    assert os.getpriority(os.PRIO_PROCESS, 0) == 19
    resource.setrlimit(resource.RLIMIT_AS, (2400*1024**2, 2400*1024**2))
    result = model_audit() if args.models else (validate(args.file) if args.file else transition_audit())
    if not args.file and not args.models:
        Path(__file__).with_name('transition_audit.json').write_text(json.dumps(result, indent=2)+'\n')
    print(json.dumps(result), flush=True)


if __name__ == '__main__':
    main()
