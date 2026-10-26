#!/usr/bin/env python3
"""A live control where the current compiler exceeds C2's exception budget."""
import hashlib
import itertools
import json
from pathlib import Path
import resource
import subprocess
import sys
from normalize_c1 import normalize, parse, takes, check_specialization
from validate_c1_controls import mem_text, ROOT
from check_c1_column_growth import lattice, ORDERS


def live_code(code):
    """Ordinary backward data/flag liveness, including implicit outputs."""
    last = {a: i for i, (op, a, b) in enumerate(code) if op == 'out'}
    live = {f'P{i}' for i in range(5) if i not in last}
    flags = False
    keep = []
    for i in range(len(code) - 1, -1, -1):
        op, a, b = code[i]
        if op == 'out':
            if last[a] == i:
                live.add(b)
                keep.append(i)
        elif op == 'cmp':
            if flags:
                live.update((a, b))
                flags = False
                keep.append(i)
        elif a in live:
            keep.append(i)
            if op == 'mov':
                live.remove(a)
            else:
                flags = True
            live.add(b)
    return sorted(keep)


def analyze_one_garbage(code, scratch='S91'):
    """Exact weak-order enumeration of five inputs and one initial garbage.

    Values retain input/garbage provenance. Only scratch 'scratch' may be read
    before a value from an input is assigned. Other unused scratch values need
    no enumeration. Equality by value handles input ties.
    """
    joint = [v for v in itertools.product(range(6), repeat=6)
             if set(v) == set(range(max(v) + 1))]
    assert len(joint) == 4683
    indices = [i for i, (op, _, _) in enumerate(code) if op not in ('cmp', 'out')]
    observations = {i: {v: set() for v in ORDERS} for i in indices}
    raw_g = {i: False for i in indices}
    for values in joint:
        inputs = values[:5]
        compressed = {x: i for i, x in enumerate(sorted(set(inputs)))}
        key = tuple(compressed[x] for x in inputs)
        # (numeric value, is an initial-garbage value)
        state = {f'P{i}': (x, False) for i, x in enumerate(inputs)}
        state[scratch] = (values[5], True)
        flag = 0
        for i, (op, a, b) in enumerate(code):
            if op == 'out':
                continue
            if op == 'cmp':
                x, y = state[a][0], state[b][0]
                flag = (x > y) - (x < y)
                continue
            if op == 'mov' or takes(op, flag):
                state[a] = state[b]
            value, garbage = state[a]
            raw_g[i] |= garbage
            observations[i][key].add('g' if garbage else compressed[value])
    rows = []
    for i in indices:
        if raw_g[i]:
            kind, witness = 'partial', None
        elif any(len(s) != 1 for s in observations[i].values()):
            kind, witness = 'garbage_controlled_full', None
        else:
            column = [next(iter(observations[i][v])) for v in ORDERS]
            yes, witness = lattice(column)
            kind = 'lattice' if yes else 'non_lattice'
        rows.append({'code_index': i, 'instruction': code[i], 'kind': kind, 'witness': witness})
    return {'joint_orders': len(joint), 'partial': sum(r['kind'] == 'partial' for r in rows),
            'non_lattice': sum(r['kind'] == 'non_lattice' for r in rows),
            'garbage_controlled_full': sum(r['kind'] == 'garbage_controlled_full' for r in rows),
            'rows': rows}


def main():
    resource.setrlimit(resource.RLIMIT_AS, (3_000_000_000, 3_000_000_000))
    prefix = parse('''cmp P0, P1
mov S90, P2
cmovl S90, P3
cmp S91, S90
cmovl S91, P0
cmp S91, P0
cmovl S91, P0
cmovge S91, P0
''')
    baseline_path = ROOT / 'agents/team/codex-fleet/w10/programs/exception_0_normalized.s'
    baseline = parse(baseline_path.read_text())
    body = [(op, 'S91' if a == 'P0' else a, 'S91' if b == 'P0' else b) for op, a, b in baseline]
    original = prefix + body
    compiler = normalize(original, 5)
    keep = live_code(original)
    assert keep == list(range(len(original))), 'control must have no ordinary dead instructions'
    for values in ORDERS:
        check_specialization(original, compiler, values)
    before = analyze_one_garbage(original)
    after = analyze_one_garbage(compiler.code)
    assert (before['partial'], before['non_lattice'], before['garbage_controlled_full']) == (2, 1, 0)
    assert (after['partial'], after['non_lattice'], after['garbage_controlled_full']) == (0, 3, 0)
    before_k = sum(op != 'out' for op, _, _ in original)
    after_k = sum(op != 'out' for op, _, _ in compiler.code)
    assert before_k == 40 and after_k == 39
    records = []
    with Path('logs/c1_live_growth_judge.log').open('w') as log:
        for name, program in [('original', original), ('normalized', compiler.code)]:
            for model in ('out', 'mem'):
                path = Path(f'programs/c1_live_growth_{name}_{model}.s')
                text = (f'# n=5 iset=I1 model=out source=w12_live_column_count_control\n'
                        + ''.join(f'{op} {a}, {b}\n' for op, a, b in program)) if model == 'out' else mem_text(program, 5)
                path.write_text(text)
                command = [sys.executable, str(ROOT / 'shared/judge.py'), str(path.resolve()),
                           '--strict', '--model', model]
                done = subprocess.run(command, text=True, capture_output=True)
                log.write(' '.join(command) + '\n' + done.stdout + done.stderr + '\n')
                log.flush()
                assert done.returncode == 0, (command, done.stdout, done.stderr)
                records.append({'path': str(path.resolve()), 'model': model,
                                'output': done.stdout, 'sha256': hashlib.sha256(path.read_bytes()).hexdigest()})
    result = {'claim': 'The current normalization maps a program with two partial and one full non-lattice written versions to three full non-lattice written versions, despite all original instructions being live under ordinary data/flag analysis.',
              'limits': 'Original k=40 and normalized k=39 exceed the k<=31 target. This refutes a column guarantee for this implementation, not existence of another reduction. The prefix ultimately computes S91=P0 and can be simplified semantically.',
              'original_k': before_k, 'normalized_k': after_k, 'original': before, 'normalized': after,
              'all_original_instructions_live': True, 'judge_records': records,
              'source_sha256': {str(p): hashlib.sha256(p.read_bytes()).hexdigest() for p in
                                (Path(__file__), Path(__file__).with_name('normalize_c1.py'),
                                 Path(__file__).with_name('check_c1_column_growth.py'))}}
    Path('analysis/c1_live_growth.json').write_text(json.dumps(result, indent=2) + '\n')
    print(json.dumps({k: result[k] for k in ('claim', 'limits', 'original_k', 'normalized_k')}, indent=2))
    print('Exact 4683 joint weak orders per program; strict judge PASS 4/4')


if __name__ == '__main__':
    main()
