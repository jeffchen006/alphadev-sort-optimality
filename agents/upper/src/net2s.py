#!/usr/bin/env python3
"""Sorting network -> naive I0 program (4 instr per comparator: mov t,a; cmp a,b; cmovg a,b; cmovg b,t).
Registers are renamed (unbounded): each comparator writes a fresh temp; outputs listed in header (free model).
Usage: net2s.py n "0-1,3-4,..." > out.s"""
import sys
n, net = int(sys.argv[1]), [tuple(map(int, c.split('-'))) for c in sys.argv[2].split(',')]
# verify by 0-1 principle
for m in range(1 << n):
    v = [(m >> i) & 1 for i in range(n)]
    for a, b in net:
        if v[a] > v[b]: v[a], v[b] = v[b], v[a]
    assert v == sorted(v), 'not a sorting network'
loc = ['P%d' % i for i in range(n)]
code, ns = [], 0
for a, b in net:
    t = 'S%d' % ns; ns += 1
    A, B = loc[a], loc[b]
    code += ['mov %s, %s' % (t, A), 'cmp %s, %s' % (A, B), 'cmovg %s, %s' % (A, B), 'cmovg %s, %s' % (B, t)]
print('# n=%d model=free iset=I0 source=net2s %s len=%d outputs: %s' % (n, sys.argv[2], len(code), ' '.join(loc)))
print('\n'.join(code))
