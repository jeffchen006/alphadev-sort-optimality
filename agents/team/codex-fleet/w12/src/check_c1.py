#!/usr/bin/env python3
"""Finite regression checks for the C1 construction. Not a sort5 UNSAT search."""
import argparse
import hashlib
import itertools
import json
import random
import time
from pathlib import Path
from normalize_c1 import OPS, normalize, check_specialization, parse


def exhaust(shard, shards, depth, n, scratch):
    names = [f'P{i}' for i in range(n)] + [f'S{i}' for i in range(scratch)]
    alphabet = list(itertools.product(OPS, names, names))
    inputs = [(0,)] if n == 1 else [(0, 0), (0, 1), (1, 0)]
    assert n in (1, 2)
    count = tests = removed = clones = 0
    max_excess = -100
    start = time.monotonic()
    for first in range(shard, len(alphabet), shards):
        for tail in itertools.product(alphabet, repeat=depth - 1):
            code = [alphabet[first], *tail]
            c = normalize(code, n, defaults=False)
            for values in inputs:
                check_specialization(code, c, values)
                tests += 1
            count += 1
            emitted = len(c.code)
            max_excess = max(max_excess, emitted - depth)
            removed += sum(ins[0] == 'cmp' for ins in code) - sum(ins[0] == 'cmp' for ins in c.code)
            clones += sum(ins[0] == 'mov' for ins in c.code)
        print(json.dumps({'shard': shard, 'first_done': first, 'programs': count}), flush=True)
    return {'check': 'all_programs_specialization_and_prefix_cost', 'n': n,
            'scratch': scratch, 'length': depth, 'alphabet': len(alphabet),
            'shard': shard, 'shards': shards, 'programs': count,
            'concrete_specialization_checks': tests, 'removed_comparisons': removed,
            'emitted_copy_instructions': clones, 'max_length_excess': max_excess,
            'seconds': time.monotonic() - start, 'accepted': True,
            'scope': 'finite compiler check; no sort5 UNSAT claim'}


def root_case():
    text = '''mov S1, S0
cmp S0, P0
cmp P1, P2
cmovg S0, P1
cmovg S1, P2
out 0, S0
out 1, S1
out 2, P0
'''
    code = parse(text)
    c = normalize(code, 3)
    values = list(itertools.product((-2147483648, -1, 0, 1, 2147483647), repeat=3))
    for v in values:
        check_specialization(code, c, v)
    Path('analysis/root_case_original.txt').write_text(text)
    Path('analysis/root_case_normalized.txt').write_text(c.text())
    Path('analysis/root_case_trace.json').write_text(json.dumps(c.trace, indent=2) + '\n')
    assert len([x for x in c.code if x[0] != 'out']) == 5
    assert [x['potential'] for x in c.trace] == [1, 2, 2, 1, 0]
    return {'check': 'root_copy_and_defined_anchor_all_read', 'inputs': len(values),
            'original_k': 5, 'normalized_k': 5, 'accepted': True,
            'sort_candidate': False}


def random_check(count=10000):
    rng = random.Random(120026)
    names = [f'P{i}' for i in range(5)] + [f'S{i}' for i in range(5)]
    tests = 0
    for _ in range(count):
        code = [(rng.choice(OPS), rng.choice(names), rng.choice(names)) for _ in range(31)]
        c = normalize(code, 5, defaults=False)
        for _ in range(5):
            x = [rng.choice((-2147483648, -1, 0, 1, 2147483647)) for _ in range(5)]
            check_specialization(code, c, x)
            tests += 1
    return {'check': 'length31_random_specialization', 'seed': 120026,
            'programs': count, 'concrete_specialization_checks': tests, 'accepted': True}


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--shard', type=int, default=0)
    parser.add_argument('--shards', type=int, default=4)
    parser.add_argument('--depth', type=int, default=3)
    parser.add_argument('--n', type=int, default=2)
    parser.add_argument('--scratch', type=int, default=2)
    parser.add_argument('--extras', action='store_true')
    args = parser.parse_args()
    if args.extras:
        result = [root_case(), random_check()]
        path = Path('analysis/c1_extras.json')
    else:
        result = exhaust(args.shard, args.shards, args.depth, args.n, args.scratch)
        path = Path(f'analysis/c1_small_{args.shard}.json')
    sources = {str(p): hashlib.sha256(p.read_bytes()).hexdigest()
               for p in (Path(__file__), Path(__file__).with_name('normalize_c1.py'))}
    path.write_text(json.dumps({'result': result, 'source_sha256': sources}, indent=2) + '\n')
    print(path.read_text(), flush=True)


if __name__ == '__main__':
    main()
