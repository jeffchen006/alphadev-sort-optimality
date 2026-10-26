#!/usr/bin/env python3
"""Build and reference-judge sorting controls for the C1 construction."""
import hashlib
import itertools
import json
from pathlib import Path
import resource
import subprocess
import sys
from normalize_c1 import normalize, parse, check_specialization

ROOT = Path('/path/to/repo')


def mem_text(code, n):
    names = sorted({r for op, a, b in code for r in ([b] if op == 'out' else [a, b])})
    names = sorted(set(names) | {f'P{i}' for i in range(n)})
    mapping = {r: f'S{i}' for i, r in enumerate(names)}
    result = [f'# n={n} R={n + len(names)} iset=I1 model=mem source=w12_C1_control']
    result += [f'mov {mapping[f"P{i}"]}, P{i}' for i in range(n)]
    explicit = set()
    for op, a, b in code:
        if op == 'out':
            explicit.add(a)
            result.append(f'mov P{a}, {mapping[b]}')
        else:
            result.append(f'{op} {mapping[a]}, {mapping[b]}')
    for i in range(n):
        if i not in explicit:
            result.append(f'mov P{i}, {mapping[f"P{i}"]}')
    return '\n'.join(result) + '\n'


def main():
    resource.setrlimit(resource.RLIMIT_AS, (3_000_000_000, 3_000_000_000))
    small = '''mov S1, S0
cmp S0, P0
cmp P0, P1
cmovg S0, P1
cmovg S1, P1
cmp P0, P1
mov S2, P0
cmovg P0, P1
cmovg P1, S2
out 0, P0
out 1, P1
'''
    seed_path = ROOT / 'agents/team/codex-fleet/w10/programs/exception_0_original.s'
    seed = seed_path.read_text()
    controls = [('c1_root_live_sort2', 2, small),
                ('c1_gcmp_sort5_control', 5, 'cmp S99, P0\n' + seed)]
    records = []
    logfile = Path('logs/c1_judge_controls.log')
    with logfile.open('w') as log:
        for label, n, text in controls:
            original = parse(text)
            c = normalize(original, n)
            for values in itertools.product(range(n), repeat=n):
                check_specialization(original, c, values)
            for suffix, body in [('original', original), ('normalized', c.code)]:
                for model in ('out', 'mem'):
                    path = Path('programs') / f'{label}_{suffix}_{model}.s'
                    if model == 'out':
                        body_text = (f'# n={n} iset=I1 model=out source=w12_C1_control\n'
                                     + ''.join(f'{op} {a}, {b}\n' for op, a, b in body))
                    else:
                        body_text = mem_text(body, n)
                    path.write_text(body_text)
                    command = [sys.executable, str(ROOT / 'shared/judge.py'),
                               str(path.resolve()), '--strict', '--model', model]
                    done = subprocess.run(command, text=True, capture_output=True)
                    log.write(' '.join(command) + '\n' + done.stdout + done.stderr + '\n')
                    log.flush()
                    assert done.returncode == 0, (command, done.stdout, done.stderr)
                    records.append({'path': str(path.resolve()), 'model': model,
                                    'returncode': done.returncode, 'judge_output': done.stdout,
                                    'sha256': hashlib.sha256(path.read_bytes()).hexdigest()})
    Path('analysis/c1_judge_controls.json').write_text(json.dumps(
        {'records': records, 'seed_path': str(seed_path),
         'seed_sha256': hashlib.sha256(seed.encode()).hexdigest()}, indent=2) + '\n')
    print(logfile.read_text())


if __name__ == '__main__':
    main()
