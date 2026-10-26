#!/usr/bin/env python3
"""Enumerate all sorting networks on n wires with exactly c comparators (min,max to (i,j), i<j),
no redundant comparator (each one changes the set of reachable 0-1 vectors), adjacent disjoint
comparators in canonical (lexicographic) order. Usage: allnets.py n c > nets.txt"""
import sys
from functools import lru_cache
n, C = int(sys.argv[1]), int(sys.argv[2])
pairs = [(i, j) for i in range(n) for j in range(i + 1, n)]
def apply(S, p):
    i, j = p
    out = set()
    for v in S:
        if (v >> i) & 1 and not (v >> j) & 1:
            v = v & ~(1 << i) | (1 << j)
        out.add(v)
    return frozenset(out)
start = frozenset(range(1 << n))
target = len([1 for _ in range(n + 1)])  # sorted vectors: n+1
@lru_cache(maxsize=None)
def feasible(S, d):
    if len(S) == n + 1:
        return True
    if d == 0:
        return False
    return any(feasible(T, d - 1) for p in pairs for T in [apply(S, p)] if T != S)
out = []
def dfs(S, d, seq):
    if len(S) == n + 1:
        if d == 0:
            out.append(list(seq))
        return
    for p in pairs:
        if seq and set(p).isdisjoint(seq[-1]) and p < seq[-1]:
            continue
        T = apply(S, p)
        if T == S or not feasible(T, d - 1):
            continue
        seq.append(p); dfs(T, d - 1, seq); seq.pop()
dfs(start, C, [])
for s in out:
    print(','.join('%d-%d' % p for p in s))
print(len(out), file=sys.stderr)
