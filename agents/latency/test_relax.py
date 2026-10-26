"""Completeness test of relax.py: random RD trees of depth exactly D (inputs + T) must give SAT
when their own function is the target.  (An over-constrained encoding would make UNSAT unsound.)
usage: python3 test_relax.py n D trials [cl]"""
import sys, os, random
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from relax import build, solve, evaluate
from prog import weak_orders
HERE = os.path.dirname(os.path.abspath(__file__))
n, D, trials = int(sys.argv[1]), int(sys.argv[2]), int(sys.argv[3])
cl = int(sys.argv[4]) if len(sys.argv) > 4 else 1
rnd = random.Random(7)
vals = list(range(n)) + ['T']

def rand_val(d):            # value tree of depth <= d
    if d <= cl or rnd.random() < 0.15:
        return ('in', rnd.choice(vals))
    return ('sel', rand_flag(d - 1), rand_val(d - 1), rand_val(d - 1))

def rand_flag(d):           # flag tree of depth <= d: cmp of values of depth <= d - cl
    return ('cmp', rand_val(d - cl), rand_val(d - cl))

def depth_v(t):
    if t[0] == 'in': return 0
    return 1 + max(depth_f(t[1]), depth_v(t[2]), depth_v(t[3]))
def depth_f(t):
    return cl + max(depth_v(t[1]), depth_v(t[2]))

W = weak_orders(n)
bad = 0; done = 0
for i in range(trials):
    t = rand_val(D)
    if depth_v(t) > D:
        continue
    f = {w: evaluate(t, w, n) for w in W}
    cnf, *_ = build(n, lambda w: f[w], D, useT=True, cl=cl)
    sat, _ = solve(cnf, os.path.join(HERE, '../../bin/kissat'), os.path.join(HERE, 'cnf', 'test_%d.cnf' % os.getpid()))
    done += 1
    if not sat:
        bad += 1; print('FAIL (UNSAT for a realisable tree):', t)
os.remove(os.path.join(HERE, 'cnf', 'test_%d.cnf' % os.getpid()))
print('n=%d D=%d cl=%d: %d random trees, %d failures' % (n, D, cl, done, bad))
