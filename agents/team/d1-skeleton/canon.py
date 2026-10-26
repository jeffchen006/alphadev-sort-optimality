#!/usr/bin/env python3
# canonical value skeletons under S5 relabelling x reversal (min<->max); input: lines "count a:b a:b ..."
import sys, itertools
sys.path.insert(0, '.')
from rsat import ev_formula
P = list(itertools.permutations(range(5)))
PI = {p: i for i, p in enumerate(P)}
def col(f): return tuple(ev_formula(f, t) for t in P)
G = []
for s in itertools.permutations(range(5)):
    for rev in (0, 1):
        # type t -> t' with t'[i] = t[s[i]] (or reversed values); column c'(t) = c(g(t)) mapped
        G.append((s, rev))
def apply(c, g):
    s, rev = g
    out = []
    for t in P:
        tt = tuple(t[s[i]] for i in range(5))
        if rev: tt = tuple(4 - v for v in tt)
        v = c[PI[tt]]
        out.append(4 - v if rev else v)
    return tuple(out)
def canon(sk):
    cols = [(col(a), col(b)) for a, b in sk]
    best = None
    for g in G:
        k = tuple(tuple(sorted((apply(a, g), apply(b, g)))) for a, b in cols)
        if best is None or k < best: best = k
    return best
if __name__ == '__main__':
    groups = {}
    for line in open(sys.argv[1]):
        p = line.split()
        n = int(p[0]); sk = [tuple(x.split(':')) for x in p[1:]]
        k = canon(sk)
        g = groups.setdefault(k, [0, ' '.join(p[1:]), 0])
        g[0] += n; g[2] += 1
    for k, (n, rep, nv) in sorted(groups.items(), key=lambda x: -x[1][0]):
        print(n, nv, rep)
