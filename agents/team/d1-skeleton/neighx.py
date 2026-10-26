#!/usr/bin/env python3
"""1-cmp neighbours of an explicit-column skeleton (dagx '=' format). Replacement operands come from the pool at
that block: index-consistent lattice columns, the skeleton's own earlier operand columns, and one-select columns
sel(F_k; A, B) (k <= block, A, B in lattice-consistent-at-k or own operands). Valid = every later operand stays
index-consistent, every cmp refines, 120 classes at the end. Output: outdir/x#####.txt
usage: neighx.py skel.txt outdir [maxpairs_per_pos]"""
import sys, os, itertools, numpy as np
sys.path.insert(0, '.')
from cons import cols, IDX, consistent_mask
P = np.array(list(itertools.permutations(range(5))), dtype=np.int8)
INV = np.argsort(P, axis=1)
def idx_of(c): return INV[np.arange(120), c]
def rd(s): return np.array([int(ch) for ch in s[1:]], dtype=np.int8)
L = [l.strip() for l in open(sys.argv[1]) if l.strip() and l[0] != '#']
sk = [(rd(l.split(':')[0]), rd(l.split(':')[1])) for l in L]
out = sys.argv[2]; os.makedirs(out, exist_ok=True)
def flags(a, b): return np.sign(a.astype(np.int64) - b) + 1
def cons1(lab, c): return len(np.unique(lab * 8 + idx_of(c))) == len(np.unique(lab))
labs = [np.zeros(120, dtype=np.int64)]
for a, b in sk: labs.append(labs[-1] * 3 + flags(a, b))
def valid(s2, j):
    lab = labs[j]
    for i in range(j, len(s2)):
        a, b = s2[i]
        if i > j and not (cons1(lab, a) and cons1(lab, b)): return False
        nl = lab * 3 + flags(a, b)
        if len(np.unique(nl)) == len(np.unique(lab)): return False
        lab = nl
    return len(np.unique(lab)) == 120
seen = set(); cnt = 0
key = lambda s: b''.join(min(a.tobytes(), b.tobytes()) + max(a.tobytes(), b.tobytes()) for a, b in s)
seen.add(key(sk))
for j in range(len(sk)):
    lab = labs[j]
    pool = {c.tobytes(): c for c in cols[np.nonzero(consistent_mask(lab))[0]]}
    for i in range(j):
        for c in sk[i]:
            if cons1(lab, c): pool[c.tobytes()] = c
    for k in range(1, j + 1):
        base = {c.tobytes(): c for c in cols[np.nonzero(consistent_mask(labs[k]))[0]]}
        for i in range(k):
            for c in sk[i]: base[c.tobytes()] = c
        F = flags(*sk[k - 1]) - 1
        lt = F < 0
        B = list(base.values())
        for A, Bc in itertools.permutations(B, 2):
            s = np.where(lt, A, Bc)
            if s.tobytes() not in pool and cons1(lab, s): pool[s.tobytes()] = s
    pl = list(pool.values())
    n0 = cnt
    if j == len(sk) - 1:  # last cmp: vectorised check (refines + separates all 120)
        M = np.stack(pl).astype(np.int16); n = len(pl)
        cls = {}
        for t, l in enumerate(lab): cls.setdefault(l, []).append(t)
        groups = [g for g in cls.values() if len(g) > 1]
        cand = []
        for i in range(n):
            ok = np.ones(n, dtype=bool); ok[:i + 1] = False
            for g in groups:
                F = np.sign(M[i, g][None, :] - M[:, g])          # [n, |g|]
                for a, b in itertools.combinations(range(len(g)), 2):
                    ok &= F[:, a] != F[:, b]
            for jj in np.nonzero(ok)[0]: cand.append((pl[i], pl[jj]))
        pairs = cand
    else:
        pairs = itertools.combinations(pl, 2)
    for x, y in pairs:
        s2 = sk[:j] + [(x, y)] + sk[j + 1:]
        if not valid(s2, j): continue
        k2 = key(s2)
        if k2 in seen: continue
        seen.add(k2); cnt += 1
        with open('%s/x%05d.txt' % (out, cnt), 'w') as f:
            f.write('# neighbour of %s pos %d\n' % (sys.argv[1], j + 1))
            for a, b in s2: f.write('=%s:=%s\n' % (''.join(map(str, a)), ''.join(map(str, b))))
    print('pos', j + 1, 'pool', len(pl), 'new', cnt - n0, file=sys.stderr, flush=True)
