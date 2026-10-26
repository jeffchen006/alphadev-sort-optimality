#!/usr/bin/env python3
# d7: near_pools.py PROGFILE PREFIX : for each program, pool = base pool + its garbage-free columns (if <= 22 non-input)
import sys, pickle
from show import progs
from pool_from_prog import sim
base = [tuple(c) for c in pickle.load(open('pool_base_cols.pkl', 'rb'))]
n = 0; sizes = []
for i, p in enumerate(progs(sys.argv[1])):
    pool = list(base)
    for c in sim(p):
        if c not in pool: pool.append(c)
    sizes.append(len(pool) - 23)
    if len(pool) - 5 > 22: continue
    with open('%s%d.txt' % (sys.argv[2], i), 'w') as f:
        for c in pool: f.write(' '.join(map(str, c)) + '\n')
    n += 1
print(n, 'pools; extra sizes', sorted(sizes))
