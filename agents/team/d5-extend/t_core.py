import sys, time; sys.path.insert(0, '.')
from d5lib import read_progs
from ext_sat import solve
ps = read_progs('../../upper/runs/r4/s5k32_coll.txt.gz')
next(ps); p = next(ps)
keep = [0,1,2,3,4,5,6,7,8,9,10,11,12,20,21,22,25,26,27,28]
core = [p[i] for i in keep]
K = int(sys.argv[1]); mode = sys.argv[2]
fp = keep if mode == 'fix' else None
print(K, mode, solve(core, K, extra=int(sys.argv[3]), verbose=True, fix_pos=fp), flush=True)
