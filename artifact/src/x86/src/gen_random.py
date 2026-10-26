#!/usr/bin/env python3
"""Random I1 programs for semantic fuzzing: gen_random.py OUTDIR COUNT N NS LEN SEED"""
import random, sys, os
out, cnt, n, ns, L, sd = sys.argv[1], *map(int, sys.argv[2:])
rng = random.Random(sd); os.makedirs(out, exist_ok=True)
regs = ['P%d' % i for i in range(n)] + ['S%d' % i for i in range(ns)]
for k in range(cnt):
    ops = []
    for _ in range(L):
        op = rng.choice(['mov', 'cmp', 'cmp', 'cmovl', 'cmovg', 'cmovle', 'cmovge'])
        ops.append('%s %s, %s' % (op, rng.choice(regs), rng.choice(regs)))  # D == S allowed
    open('%s/r%04d.s' % (out, k), 'w').write('# n=%d iset=I1 source=random seed=%d\n' % (n, sd) + '\n'.join(ops) + '\n')
