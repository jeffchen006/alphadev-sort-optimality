#!/usr/bin/env python3
# d7: pool_from_prog.py PROGFILE OUT [idx...] : all garbage-free register columns (541 weak orders) that occur in the
# given programs (# prog separated); inputs first. Prints pool size.
import sys, itertools
from show import progs
W = [v for v in itertools.product(range(5), repeat=5) if set(v) == set(range(len(set(v))))]
U = None
def sim(prog):
    regs = {'P%d' % i: tuple(w[i] for w in W) for i in range(5)}
    fl = None; cols = []
    for ins in prog:
        o, a = ins.split(None, 1); a = [x.strip() for x in a.split(',')]
        if o == 'out': continue
        d, s = a
        D = regs.get(d, (U,) * 541); S = regs.get(s, (U,) * 541)
        if o == 'mov': regs[d] = S
        elif o == 'cmp': fl = [None if x is None or y is None else (x > y) - (x < y) for x, y in zip(D, S)]
        else:
            cs = {'cmovl': (-1,), 'cmovle': (-1, 0), 'cmovg': (1,), 'cmovge': (1, 0)}[o]
            regs[d] = tuple((x if x == y else None) if (fl is None or fl[k] is None) else (y if fl[k] in cs else x) for k, (x, y) in enumerate(zip(D, S)))
        if None not in regs[d]: cols.append(regs[d])
    return cols
if __name__ == "__main__":
    pool = [tuple(w[i] for w in W) for i in range(5)]
    want = set(int(x) for x in sys.argv[3:])
    for i, p in enumerate(progs(sys.argv[1])):
        if want and i not in want: continue
        for c in sim(p):
            if c not in pool: pool.append(c)
    with open(sys.argv[2], 'w') as f:
        for c in pool: f.write(' '.join(map(str, c)) + '\n')
    print(len(pool))
