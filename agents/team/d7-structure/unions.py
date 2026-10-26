#!/usr/bin/env python3
# d7: union pools of two c=8 class pools; pool B mapped by every S5 x rev symmetry, keep unions with <= 24 non-input
# terms, prefer max overlap; columns via evcol of lattice fams, non-lattice columns mapped directly on weak orders.
import itertools, pickle
from pool_from_prog import W
PERMS = list(itertools.permutations(range(5)))
wi = {w: i for i, w in enumerate(W)}
def mapper(g, rev):
    p = PERMS[g]
    # type w -> w' with w'[i] = w[p[i]] (reversed values if rev); column c'(w) = c(w')
    idx = []
    for w in W:
        ww = tuple(w[p[i]] for i in range(5))
        if rev: m = max(ww); ww = tuple(m - v for v in ww)
        idx.append(wi[ww])
    return idx
maps = [(mapper(g, r), r) for r in (0, 1) for g in range(120)]
def apply(col, mp):
    idx, rev = mp
    if not rev: return tuple(col[j] for j in idx)
    out = []
    for k, j in enumerate(idx):
        m = max(W[k]); out.append(m - col[j])
    return tuple(out)
def load(f): return [tuple(map(int, l.split())) for l in open(f)]
P = {'w6': load('pools/w6_0.txt'), 'c2': load('pools/c8cls2_0.txt'), 'c3': load('pools/c8cls3_0.txt')}
n = 0; seen = set()
for a, b in [('w6', 'c2'), ('w6', 'c3'), ('c2', 'c3'), ('w6', 'w6'), ('c2', 'c2'), ('c3', 'c3')]:
    A = P[a]; SA = set(A); res = []
    for mp in maps:
        B = [apply(c, mp) for c in P[b]]
        if set(B[:5]) != set(A[:5]): continue  # inputs must map to inputs (always true) 
        u = A + [c for c in B if c not in SA]
        if len(u) - 5 <= 24 and len(u) > len(A):
            res.append((len(u), u))
    res.sort(key=lambda x: x[0])
    for L, u in res:
        key = frozenset(u)
        if key in seen: continue
        seen.add(key)
        with open('pools/un_%d.txt' % n, 'w') as f:
            for c in u: f.write(' '.join(map(str, c)) + '\n')
        n += 1
    print(a, b, 'unions kept', len([1 for L, u in res]), 'sizes', sorted(set(L for L, u in res))[:6])
print('total distinct union pools', n)
