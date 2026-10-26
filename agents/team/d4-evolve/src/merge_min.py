# exact min k for merge(sorted x0<=x1, sorted x2<=x3<=x4) in M_out I1 (relaxed T model, nop mode <= k, rule canon)
import sys, itertools, time
sys.path.insert(0, '../../sat')
from encode import Enc
from pysat.solvers import Solver
ws = [v for v in itertools.product(range(5), repeat=5) if set(v) == set(range(len(set(v)))) and v[0] <= v[1] and v[2] <= v[3] <= v[4]]
for k in range(int(sys.argv[1]), int(sys.argv[2]) + 1):
    t0 = time.time()
    e = Enc(5, k, R=5 + int(sys.argv[3]), iset='I1', outmode='snap', rules=('canon',), nop=True)
    for w in ws: e.add_type(w)
    s = Solver(name='cadical195', bootstrap_with=e.clauses)
    r = s.solve()
    print('k<=%d' % k, 'SAT' if r else 'UNSAT', '%.1fs' % (time.time() - t0), flush=True)
    if r:
        p, om = e.decode(s.get_model()); print(p, om); break
