#!/usr/bin/env python3
# d7: prog2skel.py PROG OUT : value skeleton (d1 dagx format "# comment" + "a:b" lattice formulas per cmp)
import sys
from show import progs, name
p = next(progs(sys.argv[1]))
regs = {'P%d' % i: [(S >> i) & 1 for S in range(32)] for i in range(5)}
CS = {'cmovl': (-1,), 'cmovle': (-1, 0), 'cmovg': (1,), 'cmovge': (1, 0)}
fl = None; sk = []
for ins in p:
    o, a = ins.split(None, 1); a = [x.strip() for x in a.split(',')]
    if o == 'out': continue
    d, s = a; D = regs.get(d, [None] * 32); S = regs.get(s, [None] * 32)
    if o == 'mov': regs[d] = list(S)
    elif o == 'cmp':
        fl = [None if x is None or y is None else (x > y) - (x < y) for x, y in zip(D, S)]; sk.append((name(D), name(S)))
    else: regs[d] = [(x if x == y else None) if fl is None or fl[k] is None else (y if fl[k] in CS[o] else x) for k, (x, y) in enumerate(zip(D, S))]
with open(sys.argv[2], 'w') as f:
    f.write('# d7 k=32 family from %s\n' % sys.argv[1] + ''.join('%s:%s\n' % ab for ab in sk))
print(' '.join('%s:%s' % ab for ab in sk))
