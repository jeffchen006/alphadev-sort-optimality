#!/usr/bin/env python3
"""d1-skeleton: enumerate lattice cmp skeletons (operands = lattice polynomials that are index-consistent at the
block before the cmp, i.e. creatable by cmov selections), c cmps, every cmp refines the order-type partition,
max class <= 2^(c-j) (perms: 2 outcomes), all 120 perms separated at the end. Dedupe up to S5 x reversal.
usage: gensk.py c [maxneeded] > list"""
import numpy as np, itertools, sys, pickle
sys.path.insert(0, '.')
from cons import cols, names, IDX, consistent_mask
from lattice import P, PA
NC = len(names)
PI = {p: i for i, p in enumerate(P)}
# group action on columns: g = (s, rev); column c' (t) = f(c(g t))
key2i = {cols[i].tobytes(): i for i in range(NC)}
G = []
for s in itertools.permutations(range(5)):
    for rev in (0, 1):
        idx = []
        for t in P:
            tt = tuple(t[s[i]] for i in range(5))
            if rev: tt = tuple(4 - v for v in tt)
            idx.append(PI[tt])
        idx = np.array(idx)
        C2 = cols[:, idx]
        if rev: C2 = 4 - C2
        G.append(np.array([key2i[C2[i].tobytes()] for i in range(NC)], dtype=np.int32))
G = np.stack(G)  # [240, NC]
BASE = int(__import__("os").environ.get("BASE", "3"))
INPUT = set(names.index(str(i)) for i in range(5))

def canon(seq):
    a = np.array(seq, dtype=np.int32)          # [j,2]
    T = G[:, a]                                # [240,j,2]
    T = np.sort(T, axis=2).reshape(240, -1)
    best = min(map(tuple, T))
    return best

def run(c, maxneed):
    level = {canon([(names.index('0'), names.index('1'))]): [(names.index('0'), names.index('1'))]}
    for j in range(1, c):
        nxt = {}
        for key, seq in level.items():
            labels = np.zeros(120, dtype=np.int64)
            for a, b in seq:
                labels = labels * 3 + (np.sign(cols[a].astype(int) - cols[b]) + 1)
            m = np.nonzero(consistent_mask(labels))[0]
            need = set(x for p in seq for x in p) - INPUT
            for ia, a in enumerate(m):
                for b in m[ia + 1:]:
                    nl = labels * 3 + (np.sign(cols[a].astype(int) - cols[b]) + 1)
                    _, cnt = np.unique(nl, return_counts=True)
                    if len(cnt) == len(np.unique(labels)):
                        continue  # no refinement
                    if cnt.max() > BASE ** (c - j - 1):
                        continue
                    nn = len(need | ({a, b} - INPUT))
                    if nn > maxneed:
                        continue
                    s2 = seq + [(a, b)]
                    k = canon(s2)
                    if k not in nxt:
                        nxt[k] = s2
        level = nxt
        print('level', j + 1, 'skeletons', len(level), file=sys.stderr, flush=True)
    return level

if __name__ == '__main__':
    c = int(sys.argv[1]); mn = int(sys.argv[2]) if len(sys.argv) > 2 else 99
    lev = run(c, mn)
    out = []
    for k, seq in lev.items():
        need = set(x for p in seq for x in p) - INPUT
        out.append((len(need), seq))
    out.sort()
    for nn, seq in out:
        print(nn, ' '.join('%s:%s' % (names[a], names[b]) for a, b in seq))
