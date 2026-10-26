#!/usr/bin/env python3
"""Check every split order, including the root and defined anchor, up to m=5."""
import hashlib
import itertools
import json
from pathlib import Path
import resource
from normalize_c1 import normalize, check_specialization


def main():
    resource.setrlimit(resource.RLIMIT_AS, (3_000_000_000, 3_000_000_000))
    orders = [v for v in itertools.product(range(4), repeat=4)
              if set(v) == set(range(max(v) + 1))]
    assert len(orders) == 75
    counts = []
    for m in range(1, 6):
        programs = tests = 0
        members = [f'S{i}' for i in range(m)] + ['P0']
        for order in itertools.permutations(members):
            for opcode in ('cmovl', 'cmovle', 'cmovg', 'cmovge'):
                code = [('mov', f'S{i}', 'S0') for i in range(1, m)]
                code += [('cmp', 'S0', 'P0'), ('cmp', 'P1', 'P2')]
                code += [(opcode, dest, 'P3') for dest in order]
                c = normalize(code, n=4, defaults=False)
                assert len(code) == len(c.code) == 2 * m + 2
                assert c.potential() == 0
                assert sum(ins[0] == 'mov' for ins in c.code) == m
                for values in orders:
                    check_specialization(code, c, values)
                    tests += 1
                programs += 1
        counts.append({'unbound_members': m, 'defined_anchors': 1,
                       'later_conditional_reads': m + 1,
                       'programs': programs, 'input_order_checks': tests,
                       'original_k': 2 * m + 2, 'normalized_k': 2 * m + 2,
                       'accepted': True})
    result = {'scope': 'all root/copy/anchor split permutations for m=1..5; four uniform cmov conditions',
              'cases': counts, 'programs': sum(c['programs'] for c in counts),
              'input_order_checks': sum(c['input_order_checks'] for c in counts),
              'remaining': 0, 'unknown': 0,
              'source_sha256': {str(p): hashlib.sha256(p.read_bytes()).hexdigest()
                                for p in (Path(__file__), Path(__file__).with_name('normalize_c1.py'))}}
    Path('analysis/c1_root_families.json').write_text(json.dumps(result, indent=2) + '\n')
    print(json.dumps(result, indent=2))


if __name__ == '__main__':
    main()
