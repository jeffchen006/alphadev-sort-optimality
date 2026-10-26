#!/usr/bin/env python3
# prog2skel.py n prog.s > skel.txt : explicit operand columns of each cmp (dagx "=" format, perms lex order)
import sys, itertools
n = int(sys.argv[1]); P = list(itertools.permutations(range(n)))
lines = [l.split('#')[0].strip() for l in open(sys.argv[2])]
lines = [l for l in lines if l and not l.startswith('out')]
cols = []
for t in P:
    r = {'P%d' % i: t[i] for i in range(n)}; fl = None; k = 0
    for l in lines:
        op, rest = l.split(None, 1); d, s = [x.strip() for x in rest.split(',')]
        if op == 'cmp':
            if len(cols) <= k: cols.append(([], []))
            cols[k][0].append(r[d]); cols[k][1].append(r[s]); k += 1
            fl = 'l' if r[d] < r[s] else 'g' if r[d] > r[s] else 'e'
        elif op == 'mov': r[d] = r[s]
        else:
            c = op[4:]
            if (fl == 'l' and 'l' in c) or (fl == 'g' and 'g' in c) or (fl == 'e' and c.endswith('e')): r[d] = r[s]
print('# from %s' % sys.argv[2])
for a, b in cols: print('=%s:=%s' % (''.join(map(str, a)), ''.join(map(str, b))))
