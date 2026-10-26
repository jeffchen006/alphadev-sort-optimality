"""template from a k=32 program + keep set (core instr indices): core cmp slots fixed (explicit columns), ext cmps '*'.
usage: mktpl.py global_index keep_csv > tpl"""
import sys, itertools; sys.path.insert(0, '..')
from d5lib import read_progs
gi = int(sys.argv[1]); keep = set(int(x) for x in sys.argv[2].split(','))
for i, p in enumerate(read_progs('/path/to/repo/agents/upper/runs/r4/s5k32_coll.txt.gz')):
    if i == gi: break
P = list(itertools.permutations(range(5)))
cols = []; cidx = [i for i, x in enumerate(p) if x[0] == 'cmp']
for t in P:
    r = {'P%d' % i: t[i] for i in range(5)}; fl = None; k = 0
    for o, d, s in p:
        if o == 'cmp':
            if len(cols) <= k: cols.append(([], []))
            cols[k][0].append(r.get(d, 9)); cols[k][1].append(r.get(s, 9)); k += 1
            fl = 'l' if r[d] < r[s] else 'g' if r[d] > r[s] else 'e'
        elif o == 'mov': r[d] = r[s]
        else:
            c = o[4:]
            if (fl == 'l' and 'l' in c) or (fl == 'g' and 'g' in c) or (fl == 'e' and c.endswith('e')): r[d] = r[s]
for k, ci in enumerate(cidx):
    print('=%s:=%s' % (''.join(map(str, cols[k][0])), ''.join(map(str, cols[k][1]))) if ci in keep else '*')
