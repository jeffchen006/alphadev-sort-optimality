#!/usr/bin/env python3
# d7: non-lattice select columns sel = cond(cmp p,q) ? s : d over base-pool terms, with (p,q) = a virtual comparator
# pair of the DAG; writes sels.pkl (list of columns) for pool runs
import pickle, itertools
G, dec, pool = pickle.load(open('decide_1.pkl', 'rb')); pool = pool[:23]
base = pickle.load(open('pool_base_cols.pkl', 'rb'))
pairs = sorted(set(tuple(sorted((pool.index(a), pool.index(b)))) for op, a, b in G))
cols = set(map(tuple, base)); out = []
for pi, qi in pairs:
    P, Q = base[pi], base[qi]
    fl = [(x > y) - (x < y) for x, y in zip(P, Q)]
    for cs in ((-1,), (-1, 0)):
        for d, s in itertools.permutations(range(23), 2):
            D, S = base[d], base[s]
            v = tuple(S[k] if fl[k] in cs else D[k] for k in range(541))
            if v not in cols: cols.add(v); out.append(v)
print(len(pairs), 'pairs', len(out), 'new select columns')
pickle.dump(out, open('sels.pkl', 'wb'))
