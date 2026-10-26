import sys, time, random; sys.path.insert(0, '.')
from d5lib import read_progs
from ext_sat import Ext
ps = read_progs('../../upper/runs/r4/s5k32_coll.txt.gz'); next(ps); p = next(ps)
keep = [0,1,2,3,4,5,6,7,8,9,10,11,12,20,21,22,25,26,27,28]
rel = sys.argv[1] == 'rel'; ntest = int(sys.argv[2]); fp = keep if sys.argv[3] == 'fix' else None
e = Ext([p[i] for i in keep], int(sys.argv[4]), extra=2, fix_pos=fp, relaxed=rel)
W = e.W; perms = [i for i in range(len(W)) if len(set(W[i])) == 5]
for i in random.Random(0).sample(perms, ntest): e.add_test(i)
t = time.time(); print(sys.argv[1:], e.S.solve(), '%.1f' % (time.time() - t), flush=True)
