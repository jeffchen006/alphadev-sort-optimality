"""Mux-tree construction (upper bound for depth): output j = tree of sel nodes whose flags are input
comparisons cmp(x_i, x_k) (depth 1); a tree of height h has depth h + 1.  Exact minimum height by
memoised search over the set of weak order types consistent with the path.  Ties: the 'not lt' branch
holds x_i >= x_k.  Result trees go to construct/lsched and are judge-checked.
usage: python3 dtree.py n [--out f.s]"""
import sys, os, argparse
from functools import lru_cache
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from prog import weak_orders, check, depth, LAT, counts
from lsched import compile_dag

ap = argparse.ArgumentParser()
ap.add_argument('n', type=int); ap.add_argument('--out', default=None)
a = ap.parse_args()
n = a.n
W = weak_orders(n)
pairs = [(i, k) for i in range(n) for k in range(n) if i != k]


def leaf(S, j):
    for c in range(n):
        if all(W[w][c] == sorted(W[w])[j] for w in S):
            return c
    return None


@lru_cache(maxsize=None)
def solve(S, j, h):
    """tree of height <= h for output j on the order types S (frozenset), or None"""
    c = leaf(S, j)
    if c is not None:
        return ('in', c)
    if h == 0:
        return None
    for (i, k) in pairs:
        L = frozenset(w for w in S if W[w][i] < W[w][k])
        G = S - L
        if not L or not G:
            continue
        tl = solve(L, j, h - 1)
        if tl is None:
            continue
        tg = solve(G, j, h - 1)
        if tg is None:
            continue
        return ('sel', ('cmp', ('in', i), ('in', k)), tg, tl)
    return None


trees = []; Ds = []
for j in range(n):
    for h in range(0, 12):
        t = solve(frozenset(range(len(W))), j, h)
        if t is not None:
            trees.append(t); Ds.append(h + 1); break
    print('output %d: mux-tree height %d -> depth %d' % (j, h, h + 1), flush=True)
r = compile_dag(trees, Ds, 1, 1)
body, _, ns = r
prog = [('load', 'P%d' % i, i) for i in range(n)] + body
ok, _ = check(prog, n)
d = {m: depth(prog, LAT[m]) for m in LAT}
k = len(prog) - 2 * n
print('n=%d k=%d %s strict=%s depth U=%d %s E=%d Z2=%d' % (n, k, counts(prog), ok, d['U'][0], d['U'][1], d['E'][0], d['Z2'][0]))
if a.out:
    with open(a.out, 'w') as f:
        f.write('# n=%d R=%d iset=I0 model=out source=latency/dtree.py (mux trees on input comparisons) k=%d depthU=%d depthE=%d depthZ2=%d strict=%s\n' % (
            n, n + ns, k, d['U'][0], d['E'][0], d['Z2'][0], ok))
        for op, x, y in prog:
            if op == 'store':
                f.write('out %d, %s\n' % (x, y))
            elif op != 'load':
                f.write('%s %s, %s\n' % (op, x, y))
