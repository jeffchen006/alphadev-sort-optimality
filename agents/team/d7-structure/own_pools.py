#!/usr/bin/env python3
# d7: own_pools.py PROGFILE PREFIX : pool = program's own garbage-free columns + the 5 output columns; dedupe pools
import sys, itertools
from show import progs
from pool_from_prog import sim, W
outs = [tuple(sorted(w)[j] for w in W) for j in range(5)]
seen = set(); n = 0
for i, p in enumerate(progs(sys.argv[1])):
    pool = [tuple(w[k] for w in W) for k in range(5)]
    for c in sim(p) + outs:
        if c not in pool: pool.append(c)
    key = frozenset(pool)
    if key in seen or len(pool) - 5 > 22: continue
    seen.add(key); n += 1
    with open('%s%d.txt' % (sys.argv[2], i), 'w') as f:
        for c in pool: f.write(' '.join(map(str, c)) + '\n')
print(n, 'distinct pools')
