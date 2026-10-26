# pure insertion: P0<=P1<=P2<=P3 sorted (all weak orders of 5 with that property), insert P4; exact SAT, all tests
import sys, time; sys.path.insert(0, '.')
from ext_sat import Ext, sim_full, fmt
K = int(sys.argv[1]); extra = int(sys.argv[2])
e = Ext([], K, extra=extra)
idx = [i for i, w in enumerate(e.W) if w[0] <= w[1] <= w[2] <= w[3]]
for i in idx: e.add_test(i)
t = time.time(); r = e.S.solve()
print('K', K, 'extra', extra, 'tests', len(idx), 'SAT' if r else 'UNSAT', '%.1fs' % (time.time() - t), flush=True)
if r:
    p = e.model_prog(e.S.get_model()); print(fmt(p, sim_full(p)[1]))
