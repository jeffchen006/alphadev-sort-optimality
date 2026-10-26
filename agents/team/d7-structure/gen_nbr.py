#!/usr/bin/env python3
# d7: gen_nbr.py POOL PROG OUT.pkl : one-extra candidate columns for a pool: (a) min/max of 2 pool terms,
# (b) non-lattice/other selects cond(cmp p,q) ? s : d with (p,q) = a cmp pair of PROG, d,s pool terms. Not in pool.
import sys, itertools, pickle
from show import progs
from pool_from_prog import W
pool = [tuple(map(int, l.split())) for l in open(sys.argv[1])]
P = set(pool); out = []; seen = set(P)
def add(c):
    if c not in seen: seen.add(c); out.append(c)
for a, b in itertools.combinations(pool, 2):
    add(tuple(map(min, a, b))); add(tuple(map(max, a, b)))
nlat = len(out)
# cmp pairs of the program: simulate on weak orders
regs = {'P%d' % i: tuple(w[i] for w in W) for i in range(5)}
CS = {'cmovl': (-1,), 'cmovle': (-1, 0), 'cmovg': (1,), 'cmovge': (1, 0)}
fl = None; pairs = []
for ins in next(progs(sys.argv[2])):
    o, a = ins.split(None, 1); a = [x.strip() for x in a.split(',')]
    if o == 'out': continue
    d, s = a; D = regs.get(d); S = regs.get(s)
    if o == 'mov': regs[d] = S
    elif o == 'cmp': fl = [(x > y) - (x < y) for x, y in zip(D, S)]; pairs.append(fl)
    else:
        if D is None: regs[d] = S; continue  # conditional copy into garbage: treat as copy
        regs[d] = tuple(y if fl[k] in CS[o] else x for k, (x, y) in enumerate(zip(D, S)))
for fl in pairs:
    for cs in ((-1,), (-1, 0)):
        for D, S in itertools.permutations(pool, 2):
            add(tuple(S[k] if fl[k] in cs else D[k] for k in range(541)))
print(nlat, 'lattice extras,', len(out) - nlat, 'selects')
pickle.dump((pool, out), open(sys.argv[3], 'wb'))
