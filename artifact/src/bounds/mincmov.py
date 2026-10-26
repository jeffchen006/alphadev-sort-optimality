#!/usr/bin/env python3
"""Exact minimum #cmov over ALL programs (any length, cmp and mov free, unbounded registers), M_out, I1, T-relaxed,
permutations only.  Relaxation 'R1': with free mov every cmov can write a fresh copy, so the set A of available
columns only grows; with free cmp any flag vector from two available columns (or T) is available.
A program with m cmov gives an R1 run with <= m adds, so 'no R1 run with <= M adds' => #cmov >= M+1 for every program.
IDDFS with the admissible bound max(a, Huffman-sum) (BOUNDS.md §H, H2/H3).
usage: mincmov.py n MAXM
"""
import sys, itertools, math, heapq

n = int(sys.argv[1]); MAXM = int(sys.argv[2])
P = list(itertools.permutations(range(n)))
T = n
NP = len(P)
INPUT = [tuple(i for _ in P) for i in range(n)]                    # column of P_i: symbol i on every perm
TARGET = [tuple(sorted(range(n), key=lambda q: p[q])[j] for p in P) for j in range(n)]
TCOL = tuple(T for _ in P)


def huff(ws):
    ws = [w for w in ws if w > 0]
    if len(ws) <= 1:
        return 0.0
    heapq.heapify(ws); c = 0.0
    while len(ws) > 1:
        x = heapq.heappop(ws); y = heapq.heappop(ws); c += x + y; heapq.heappush(ws, x + y)
    return c


def h(A):
    tot = 0.0
    for t in TARGET:
        if t in A:
            continue
        holders = []
        for i in range(NP):
            hs = [c for c in A if c[i] == t[i]]
            if not hs:
                return 10 ** 9
            holders.append(hs)
        if all(len(x) == 1 for x in holders):
            cnt = {}
            for x in holders:
                cnt[x[0]] = cnt.get(x[0], 0) + 1
            tot += huff([v / NP for v in cnt.values()])
        else:
            tot += 1
    return math.ceil(tot - 1e-9)


def V(i, sym):
    return 10 ** 6 if sym == T else P[i][sym]


def flags(a, b):
    return tuple((V(i, a[i]) < V(i, b[i])) - (V(i, a[i]) > V(i, b[i])) for i in range(NP))   # 1 lt, -1 gt, 0 eq


def children(A):
    cols = list(A) + [TCOL]
    fl = set()
    for a, b in itertools.combinations(cols, 2):
        fl.add(flags(a, b))
    out = set()
    for f in fl:
        for cond in ((1,), (-1,), (1, 0), (-1, 0)):                   # l, g, le, ge
            fire = [f[i] in cond for i in range(NP)]
            if not any(fire):
                continue
            for S in A:
                for D in cols:
                    M = tuple(S[i] if fire[i] else D[i] for i in range(NP))
                    if M in A or M == TCOL:
                        continue
                    out.add(M)
    return out


seen = {}


def dfs(A, budget):
    if all(t in A for t in TARGET):
        return True
    if h(A) > budget:
        return False
    key = A
    if seen.get(key, -1) >= budget:
        return False
    seen[key] = budget
    for M in children(A):
        if dfs(A | {M}, budget - 1):
            return True
    return False


A0 = frozenset(INPUT)
print('root h =', h(A0), flush=True)
for m in range(h(A0), MAXM + 1):
    seen.clear()
    r = dfs(A0, m)
    print(f'n={n} m<={m}:', 'FOUND' if r else 'none', 'states', len(seen), flush=True)
    if r:
        break
