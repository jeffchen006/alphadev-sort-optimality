"""Short min-depth programs: joint relaxed DAG WITHOUT T and with node budget K, compiled by the
sharing compiler of construct.py (Gen2), checked strict.  Upper bounds for the Pareto front.
usage: python3 compile_joint.py n D0,..,D{n-1} K [--cl c] [--model U|E] [--out f.s]"""
import sys, os, argparse
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from relax_joint import build_joint, decode_joint
from relax import solve
from construct import Gen2
from lsched import compile_dag
from prog import check, depth, LAT, counts
HERE = os.path.dirname(os.path.abspath(__file__))
ap = argparse.ArgumentParser()
ap.add_argument('n', type=int); ap.add_argument('D'); ap.add_argument('K', type=int)
ap.add_argument('--cl', type=int, default=1); ap.add_argument('--i1', action='store_true'); ap.add_argument('--model', default='U'); ap.add_argument('--out', default=None)
a = ap.parse_args()
n = a.n
Ds = [int(x) for x in a.D.split(',')]
Ds = Ds * n if len(Ds) == 1 else Ds
from prog import weak_orders
def ev(t, w):
    if t[0] == 'in':
        return t[1]
    f, x, y = t[1], t[2], t[3]
    p, q = w[ev(f[1], w)], w[ev(f[2], w)]
    cond = (p > q) if (len(t) > 4 and t[4]) else (p < q)
    return ev(y if cond else x, w)
allW = weak_orders(n)
Wsub = [w for w in allW if len(set(w)) == n]     # CEGIS: start with the permutations
while True:
    cnf, *_ = build_joint(n, Ds, a.K, useT=False, cl=a.cl, W=Wsub)
    path = os.path.join(HERE, 'cnf', 'cj_%d.cnf' % os.getpid())
    sat, model = solve(cnf, os.path.join(HERE, '../../bin/kissat'), path)
    os.remove(path)
    if not sat:
        print('no T-free joint DAG with K=%d' % a.K); sys.exit(1)
    trees = decode_joint(model, cnf.meta)
    bad = [w for w in allW if any(w[ev(t, w)] != sorted(w)[j] for j, t in enumerate(trees))]
    if not bad:
        break
    Wsub.append(bad[0])
    print('  cegis |W|=%d' % len(Wsub), flush=True)
r = compile_dag(trees, Ds, 1 if a.model == 'U' else 0, a.cl, a.i1)
if r is not None:
    body, _, nsc = r
    prog = [('load', 'P%d' % i, i) for i in range(n)] + body
    class G: pass
    g = G(); g.ns = nsc
else:
    print('list scheduler failed; tree/sharing fallback')
    g = Gen2(n, 1 if a.model == 'U' else 0, a.cl)
    for t in trees:
        g.count(t); g.uses[t] += 1
    outs = [g.read(t) for t in trees]
    prog = g.prog + [('store', j, outs[j]) for j in range(n)]
ok, _ = check(prog, n)
d = {m: depth(prog, LAT[m]) for m in LAT}
c = counts(prog); k = len(prog) - 2 * n
print('n=%d K=%d -> k=%d %s strict=%s depth U=%d %s E=%d Z2=%d' % (n, a.K, k, c, ok, d['U'][0], d['U'][1], d['E'][0], d['Z2'][0]))
if a.out:
    with open(a.out, 'w') as f:
        f.write(('# n=%d R=%d iset=' + ('I1' if a.i1 else 'I0') + ' model=out source=latency/compile_joint.py D=%s K=%d cl=%d k=%d depthU=%d depthE=%d depthZ2=%d strict=%s\n') % (
            n, n + g.ns, a.D, a.K, a.cl, k, d['U'][0], d['E'][0], d['Z2'][0], ok))
        for op, x, y in prog:
            if op == 'store':
                f.write('out %d, %s\n' % (x, y))
            elif op != 'load':
                f.write('%s %s, %s\n' % (op, x, y))
