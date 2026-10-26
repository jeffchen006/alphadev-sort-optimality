#!/usr/bin/env python3
"""Exact min cost in enum's set model (Lemma S costs: cmp 1, in-place cmov 1, cmov on T 1, copy 2), relaxed, strict
permutations, I1, for sort-n with an optional extra constant column (sentinel H above inputs, or L below inputs).
usage: ksentinel.py n {none|max|min} KMAX"""
import sys, itertools, heapq
n = int(sys.argv[1]); mode = sys.argv[2]; KMAX = int(sys.argv[3])
perms = list(itertools.permutations(range(n)))
off = 1 if mode == 'min' else 0
T = n + 1 + off
col = lambda f: tuple(f(p) for p in perms)
inputs = [col(lambda p, i=i: p[i] + off) for i in range(n)]
extra = []
if mode == 'max': extra = [col(lambda p: n)]
if mode == 'min': extra = [col(lambda p: 0)]
targets = [col(lambda p, j=j: j + off) for j in range(n)]
TC = col(lambda p: T)
COND = [lambda f: f == 1, lambda f: f == 2, lambda f: f != 2, lambda f: f != 1]  # l g le ge ; f: 0 eq 1 lt 2 gt
def canon(f):
    for x in f:
        if x == 1: return f
        if x == 2: return tuple({0: 0, 1: 2, 2: 1}[y] for y in f)
    return f
def done_of(A, done):
    return done | frozenset(j for j in range(n) if targets[j] in A)
A0 = frozenset(inputs + extra); f0 = tuple(0 for _ in perms)
start = (A0, f0, done_of(A0, frozenset()))
best = {start: 0}; pq = [(n, 0, start)]; cnt = 0; ALL = frozenset(range(n))
while pq:
    h0, _, s = heapq.heappop(pq)
    g = best[s]
    if h0 > g + n: pass
    A, f, done = s
    if done == ALL: print('n=%d mode=%s: min cost = %d (states %d)' % (n, mode, g, len(best))); sys.exit()
    if g >= KMAX: continue
    cols = list(A) + [TC]
    succ = []
    for a, b in itertools.combinations(range(len(cols)), 2):
        nf = canon(tuple(0 if x == y else (1 if x < y else 2) for x, y in zip(cols[a], cols[b])))
        if nf != f: succ.append((1, (A, nf, done)))
    for d in range(len(cols)):
        for sr in range(len(cols)):
            if d == sr: continue
            D, S = cols[d], cols[sr]
            for c in COND:
                M = tuple(S[w] if c(f[w]) else D[w] for w in range(len(perms)))
                if M == D or M == TC or M in A: continue
                nd = done_of([M], done)
                if d < len(cols) - 1:
                    succ.append((1, (frozenset(A - {D} | {M}), f, nd)))
                    succ.append((2, (frozenset(A | {M}), f, nd)))
                else:
                    succ.append((1, (frozenset(A | {M}), f, nd)))
    for cost, t in succ:
        ng = g + cost
        A2, f2, d2 = t
        und = [j for j in range(n) if j not in d2]
        dead = any(all(c[w] != targets[j][w] for c in A2) for j in und for w in range(len(perms)))
        if dead or ng + len(und) > KMAX: continue
        if ng <= KMAX and ng < best.get(t, 1e9):
            best[t] = ng; cnt += 1; heapq.heappush(pq, (ng + len(und), cnt, t))
print('n=%d mode=%s: none <= %d (states %d)' % (n, mode, KMAX, len(best)))
