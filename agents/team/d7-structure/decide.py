#!/usr/bin/env python3
# d7: for the unique gate DAG, which cmp pairs (p,q) of pool terms decide which gates (exact, all 541 weak orders).
# gate op(a,b) is decided by cmp(p,q) if some cmov (cond in l/le/g/ge, dest a or b) gives op(a,b) on every weak order.
import sys, itertools, collections as C
from gates import analyse, tname
from show import progs, COLL
W = [v for v in itertools.product(range(5), repeat=5) if set(v) == set(range(len(set(v))))]
assert len(W) == 541
def ev(t, w):
    best = -1
    for S in range(1, 32):
        if t >> S & 1:
            m = min(w[i] for i in range(5) if S >> i & 1)
            if m > best: best = m
    return best
def evcol(t): return tuple(ev(t, w) for w in W)
CONDS = {'l': (-1,), 'le': (-1, 0), 'g': (1,), 'ge': (1, 0)}
def decides(gate, p, q, cols):
    op, a, b = gate
    A, B, P, Q = cols[a], cols[b], cols[p], cols[q]
    R = [min(x, y) if op == 'min' else max(x, y) for x, y in zip(A, B)]
    fl = [(x > y) - (x < y) for x, y in zip(P, Q)]
    res = []
    for cn, cs in CONDS.items():
        for dest, src, D, S in (('a', 'b', A, B), ('b', 'a', B, A)):
            if all((S[k] if fl[k] in cs else D[k]) == R[k] for k in range(541)):
                res.append(cn + ':' + dest)
    return res
if __name__ == '__main__':
    n = int(sys.argv[1]) if len(sys.argv) > 1 else 1
    tags = open('ana.txt').readlines()[n].split()[15]
    prog = next(p for i, p in enumerate(progs(COLL)) if i == n)
    gates, copies, *_ = analyse(prog, tags)
    X = [sum(1 << S for S in range(32) if S >> i & 1) for i in range(5)]
    pool = list(dict.fromkeys(X + [g[3] for g in gates]))
    extra = len(sys.argv) > 2  # add all pairwise min/max of pool terms as extra candidate cmp operands
    if extra:
        base = list(pool)
        for a, b in itertools.combinations(base, 2):
            for t in (a & b, a | b):
                if t not in pool: pool.append(t)
    cols = {t: evcol(t) for t in pool}
    G = [(g[0], g[1], g[2]) for g in gates]
    dec = C.defaultdict(list)
    for gi, g in enumerate(G):
        for p, q in itertools.combinations(pool, 2):
            if decides(g, p, q, cols): dec[(p, q)].append(gi)
    name = {t: tname(t) for t in pool}
    for gi, g in enumerate(G):
        ds = [pq for pq, l in dec.items() if gi in l]
        print('gate %2d %s(%s, %s): %d deciders: %s' % (gi, g[0], name[g[1]], name[g[2]], len(ds), '; '.join('(%s,%s)' % (name[p], name[q]) for p, q in ds[:8])))
    print('pairs deciding >= 3 gates:')
    for pq, l in sorted(dec.items(), key=lambda x: -len(x[1])):
        if len(l) >= 3: print('  (%s, %s) -> %s' % (name[pq[0]], name[pq[1]], l))
    # min hitting set (ignore time order): set cover of 18 gates by decider pairs
    import pickle; pickle.dump((G, dict(dec), pool), open('decide_%d%s.pkl' % (n, 'x' if extra else ''), 'wb'))
