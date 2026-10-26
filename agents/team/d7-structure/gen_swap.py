#!/usr/bin/env python3
# d7: gen_swap.py POOL PROG OUT.pkl : complementary select pairs on ONE flag of PROG (conditional swap of a pair):
# (f ? S : D, f ? D : S) for D,S pool terms, cond in {l, le} (g/ge = same pairs swapped). Keeps pairs with >= 1 new column.
import sys, itertools, pickle
from show import progs
from pool_from_prog import W
pool = [tuple(map(int, l.split())) for l in open(sys.argv[1])]
P = set(pool)
regs = {'P%d' % i: tuple(w[i] for w in W) for i in range(5)}
CS = {'cmovl': (-1,), 'cmovle': (-1, 0), 'cmovg': (1,), 'cmovge': (1, 0)}
fl = None; flags = []
for ins in next(progs(sys.argv[2])):
    o, a = ins.split(None, 1); a = [x.strip() for x in a.split(',')]
    if o == 'out': continue
    d, s = a; D = regs.get(d); S = regs.get(s)
    if o == 'mov': regs[d] = S
    elif o == 'cmp': fl = [(x > y) - (x < y) for x, y in zip(D, S)]; flags.append(fl)
    else:
        if D is None: regs[d] = S; continue
        regs[d] = tuple(y if fl[k] in CS[o] else x for k, (x, y) in enumerate(zip(D, S)))
out = []; seen = set()
for fi, fl in enumerate(flags):
    for cs in ((-1,), (-1, 0)):
        for D, S in itertools.combinations(pool, 2):
            u = tuple(S[k] if fl[k] in cs else D[k] for k in range(541))
            v = tuple(D[k] if fl[k] in cs else S[k] for k in range(541))
            new = tuple(c for c in (u, v) if c not in P)
            if not new or (u == v): continue
            key = frozenset(new)
            if key in seen: continue
            seen.add(key); out.append((fi, list(new)))
print(len(flags), 'flags', len(out), 'swap pools')
pickle.dump((pool, out), open(sys.argv[3], 'wb'))
