#!/usr/bin/env python3
# d7: extra-term candidates around the base pool: lattice min/max of two pool terms (not in pool), as columns
import sys, pickle, itertools
from decide import evcol
G, dec, pool = pickle.load(open('decide_1.pkl', 'rb')); pool = pool[:23]
ex = []
for a, b in itertools.combinations(pool, 2):
    for t in (a & b, a | b):
        if t not in pool and t not in ex: ex.append(t)
print(len(ex), file=sys.stderr)
pickle.dump(ex, open('extras1.pkl', 'wb'))
base = [evcol(t) for t in pool]
open('pool_base_cols.pkl', 'wb').write(pickle.dumps(base))
