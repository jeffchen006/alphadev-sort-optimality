import sys, time; sys.path.insert(0, '.')
from d5lib import read_progs
from ext_sat import Ext, FOPS
ps = read_progs('../../upper/runs/r4/s5k32_coll.txt.gz')
next(ps); p = next(ps)
keep = [0,1,2,3,4,5,6,7,8,9,10,11,12,20,21,22,25,26,27,28]
e = Ext([p[i] for i in keep], 32, extra=2, fix_pos=keep)
used = {x for i in keep for x in p[i][1:]}
ren = {}
for o, d, s in p:
    for x in (d, s):
        if x[0] == 'S' and x not in used and x not in ren: ren[x] = 'E%d' % len(ren)
print(ren)
ass = []
for t, (o, d, s) in enumerate(p):
    d = ren.get(d, d); s = ren.get(s, s)
    ass += [e.op[t][FOPS.index(o)], e.d[t][e.ri[d]], e.s[t][e.ri[s]]]
import random
for i in random.Random(0).sample(range(541), 20): e.add_test(i)
t=time.time(); r = e.S.solve(assumptions=ass); print(r, time.time()-t)
if not r: print(e.S.get_core())
t=time.time(); r = e.S.solve(); print('free', r, time.time()-t)
