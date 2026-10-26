"""own: cmp operand columns (120 perms, lex order) of a program file -> dagx explicit skeleton (one cmp per line)"""
import sys, itertools
L = [l.split('#')[0].strip() for l in open(sys.argv[1])]
prog = []
for l in L:
    if not l or l.startswith('out'): continue
    o, r = l.split(None, 1); d, s = [x.strip() for x in r.split(',')]; prog.append((o, d, s))
cols = []
for t in itertools.permutations(range(5)):
    r = {'P%d' % i: t[i] for i in range(5)}; fl = None; k = 0
    for o, d, s in prog:
        if o == 'cmp':
            if len(cols) <= k: cols.append(([], []))
            cols[k][0].append(r[d]); cols[k][1].append(r[s]); k += 1
            fl = 'l' if r[d] < r[s] else 'g' if r[d] > r[s] else 'e'
        elif o == 'mov': r[d] = r[s]
        else:
            c = o[4:]
            if (fl == 'l' and 'l' in c) or (fl == 'g' and 'g' in c) or (fl == 'e' and c.endswith('e')): r[d] = r[s]
for a, b in cols: print('=%s:=%s' % (''.join(map(str, a)), ''.join(map(str, b))))
