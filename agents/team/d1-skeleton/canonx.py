# canonical key of explicit-column skeletons mod S5 x reversal; prints groups
import sys, itertools, numpy as np
P = list(itertools.permutations(range(5))); PI = {p: i for i, p in enumerate(P)}
G = []
for s in itertools.permutations(range(5)):
    for rev in (0, 1):
        idx = []
        for t in P:
            tt = tuple(t[s[i]] for i in range(5))
            if rev: tt = tuple(4 - v for v in tt)
            idx.append(PI[tt])
        G.append((np.array(idx), rev))
def rd(x): return np.array([int(c) for c in x[1:]], dtype=np.int8)
groups = {}
for fn in sys.argv[1:]:
    sk = [tuple(rd(x) for x in l.strip().split(':')) for l in open(fn) if l.strip() and l[0] != '#']
    best = None
    for idx, rev in G:
        k = []
        for a, b in sk:
            a2, b2 = a[idx], b[idx]
            if rev: a2, b2 = 4 - a2, 4 - b2
            x, y = a2.tobytes(), b2.tobytes(); k.append(min(x, y) + max(x, y))
        k = b''.join(k)
        if best is None or k < best: best = k
    groups.setdefault(best, []).append(fn)
for i, (k, fs) in enumerate(groups.items()): print('class', i + 1, ' '.join(f.split('/')[-1] for f in fs))
