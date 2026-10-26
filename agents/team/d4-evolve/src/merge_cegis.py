# exact: is there a k-instruction M_out I1 program merging sorted x0<=x1 and sorted x2<=x3<=x4 ? (CEGIS over the 76
# weak orders with that property; relaxed T model; no rules; dead instructions allowed so "k" means "<= k")
import sys, itertools, time, random
sys.path.insert(0, '../../sat'); sys.path.insert(0, '../../sort5-lab/tools')
from encode import Enc
import d4eval as E
from pysat.solvers import Solver
ws = [v for v in itertools.product(range(5), repeat=5) if set(v) == set(range(len(set(v)))) and v[0] <= v[1] and v[2] <= v[3] <= v[4]]
k, nsc = int(sys.argv[1]), int(sys.argv[2])
rnd = random.Random(1)
e = Enc(5, k, R=5 + nsc, iset='I1', outmode='snap', nop=False)
s = Solver(name='cadical195'); pushed = 0
for w in rnd.sample(ws, 6): e.add_type(w)
t0 = time.time()
while True:
    for c in e.clauses[pushed:]: s.add_clause(c)
    pushed = len(e.clauses)
    r = s.solve()
    print('types %d %s %.1fs' % (len(e.types), r, time.time() - t0), flush=True)
    if not r: print('RESULT UNSAT k=%d nsc=%d' % (k, nsc)); break
    p, om = e.decode(s.get_model())
    nm = lambda r: 'P%d' % r if r < 5 else 'S%d' % (r - 5)
    txt = []
    for i, (op, d, sr) in enumerate(p):
        txt.append((op, nm(d), nm(sr)))
        for j, (tm, reg) in enumerate(om):
            if tm == i + 1: txt.append(('out', str(j), nm(reg)))
    bad = [w for w in ws if E.run(txt, 5, w) != sorted(w)]
    if not bad: print('RESULT SAT k=%d' % k); print(E.fmt(txt)); break
    e.add_type(rnd.choice(bad))
