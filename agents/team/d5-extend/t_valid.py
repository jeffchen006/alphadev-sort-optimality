import sys; sys.path.insert(0,'.')
from d5lib import read_progs
from ext_sat import solve, sim_full
p = next(iter(read_progs('../../upper/runs/r4/s5k32_coll.txt.gz')))
print(sim_full(p)[0])
nc = int(sys.argv[1]); K = int(sys.argv[2])
print(solve(p[:nc], K, extra=3, verbose=True, fix_pos=(list(range(nc)) if len(sys.argv)>3 else None)))
