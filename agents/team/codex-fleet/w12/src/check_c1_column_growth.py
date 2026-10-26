#!/usr/bin/env python3
"""Exhibit exception-count growth in this compiler; not a lower-bound result."""
import hashlib
import itertools
import json
from pathlib import Path
import resource
import subprocess
import sys
from normalize_c1 import normalize, parse, takes, check_specialization
from validate_c1_controls import mem_text, ROOT

ORDERS = [v for v in itertools.product(range(5), repeat=5)
          if set(v) == set(range(max(v) + 1))]
assert len(ORDERS) == 541


def lattice(column):
    """Threshold consistency and inclusion monotonicity on all weak orders."""
    requirements = {}
    for values, result in zip(ORDERS, column):
        assert result is not None
        for threshold in range(max(values) + 2):
            mask = sum(1 << i for i, value in enumerate(values) if value >= threshold)
            bit = result >= threshold
            origin = {'input': values, 'value': result, 'threshold': threshold,
                      'mask': mask, 'bit': bit}
            if mask in requirements and requirements[mask]['bit'] != bit:
                return False, {'type': 'same_threshold_mask',
                               'first': requirements[mask], 'second': origin}
            requirements[mask] = origin
    for a, first in requirements.items():
        for b, second in requirements.items():
            if a & b == a and first['bit'] and not second['bit']:
                return False, {'type': 'inclusion', 'first': first, 'second': second}
    return True, None


def analyze(code):
    state = {f'P{i}': [v[i] for v in ORDERS] for i in range(5)}
    flags = [0] * len(ORDERS)
    unknown = [None] * len(ORDERS)
    rows = []
    core = 0
    for op, a, b in code:
        if op == 'out':
            continue
        core += 1
        left, right = state.get(a, unknown), state.get(b, unknown)
        if op == 'cmp':
            flags = [None if x is None or y is None else (x > y) - (x < y)
                     for x, y in zip(left, right)]
            continue
        if op == 'mov':
            result = list(right)
        else:
            assert all(f is not None for f in flags), 'unsupported garbage-flag data write'
            result = [y if takes(op, f) else x for x, y, f in zip(left, right, flags)]
        state[a] = result
        count = result.count(None)
        if count:
            kind, witness = 'partial', None
        else:
            is_lattice, witness = lattice(result)
            kind = 'lattice' if is_lattice else 'non_lattice'
        rows.append({'core_index': core, 'instruction': [op, a, b], 'kind': kind,
                     'garbage_entries': count, 'witness': witness})
    return {'k': core, 'partial': sum(r['kind'] == 'partial' for r in rows),
            'non_lattice': sum(r['kind'] == 'non_lattice' for r in rows),
            'lattice': sum(r['kind'] == 'lattice' for r in rows), 'rows': rows}


def main():
    resource.setrlimit(resource.RLIMIT_AS, (3_000_000_000, 3_000_000_000))
    prefix_text = '''cmp P0, P1
mov S90, P2
cmovl S90, P3
cmp S91, S90
cmp P0, P1
cmovl S91, P3
'''
    baseline_path = ROOT / 'agents/team/codex-fleet/w10/programs/exception_0_normalized.s'
    baseline = parse(baseline_path.read_text())
    assert analyze(baseline)['partial'] == analyze(baseline)['non_lattice'] == 0
    original = parse(prefix_text) + baseline
    compiler = normalize(original, 5)
    for values in ORDERS:
        check_specialization(original, compiler, values)
    original_analysis, normalized_analysis = analyze(original), analyze(compiler.code)
    assert original_analysis['k'] == normalized_analysis['k'] == 38
    assert (original_analysis['partial'], original_analysis['non_lattice']) == (1, 1)
    assert (normalized_analysis['partial'], normalized_analysis['non_lattice']) == (0, 3)
    records = []
    with Path('logs/c1_column_growth_judge.log').open('w') as log:
        for name, body in [('original', original), ('normalized', compiler.code)]:
            for model in ('out', 'mem'):
                path = Path(f'programs/c1_column_growth_{name}_{model}.s')
                text = (f'# n=5 iset=I1 model=out source=w12_column_count_control\n'
                        + ''.join(f'{op} {a}, {b}\n' for op, a, b in body)) if model == 'out' else mem_text(body, 5)
                path.write_text(text)
                command = [sys.executable, str(ROOT / 'shared/judge.py'), str(path.resolve()),
                           '--strict', '--model', model]
                done = subprocess.run(command, text=True, capture_output=True)
                log.write(' '.join(command) + '\n' + done.stdout + done.stderr + '\n')
                log.flush()
                assert done.returncode == 0, (command, done.stdout, done.stderr)
                records.append({'path': str(path.resolve()), 'model': model,
                                'output': done.stdout, 'sha256': hashlib.sha256(path.read_bytes()).hexdigest()})
    result = {'claim': 'This implementation can produce more than two non-lattice written versions from one partial and one non-lattice original version.',
              'limits': 'k=38, above the target bound. Dead prefix. Not a counterexample to existence of a better reduction or to sorting lower bounds.',
              'orders': len(ORDERS), 'original': original_analysis, 'normalized': normalized_analysis,
              'judge_records': records,
              'baseline': str(baseline_path), 'baseline_sha256': hashlib.sha256(baseline_path.read_bytes()).hexdigest(),
              'source_sha256': {str(p): hashlib.sha256(p.read_bytes()).hexdigest() for p in
                                (Path(__file__), Path(__file__).with_name('normalize_c1.py'))}}
    Path('analysis/c1_column_growth.json').write_text(json.dumps(result, indent=2) + '\n')
    print(json.dumps({k: result[k] for k in ('claim', 'limits', 'orders')}, indent=2))
    print('original k=38 q=1 r=1; normalized k=38 q=0 r=3; strict judge PASS 4/4')


if __name__ == '__main__':
    main()
