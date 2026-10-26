"""Library decision trees (upper bound for depth): output j = tree of sel nodes; flags from a library
(input comparisons, depth 1; comparisons between inputs and pair min/max, depth 3); leaves from a
library (inputs, depth 0; pair min/max, depth 2).  Node depth = 1 + max(flag depth, child depths).
A tree node is an RD value node, so the result is an RD DAG without T: compiled by lsched, judge-checked.
usage: python3 dtree2.py n D_0,..,D_{n-1} [--out f.s]"""
import sys, os, argparse, itertools, time
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from prog import weak_orders, check, depth, LAT, counts
from lsched import compile_dag

ap = argparse.ArgumentParser()
ap.add_argument('n', type=int); ap.add_argument('D'); ap.add_argument('--out', default=None)
ap.add_argument('--big', action='store_true', help='also min/max vs min/max flags')
ap.add_argument('--tlimit', type=int, default=600)
ap.add_argument('--only', type=int, default=None, help='search only this output (no program)')
ap.add_argument('--tri', action='store_true', help='also min/max of triples (depth 3) as leaves and flag operands')
a = ap.parse_args()
n = a.n
Ds = [int(x) for x in a.D.split(',')]
W = weak_orders(n)
NW = len(W)
FULL = (1 << NW) - 1

def ev(t, w):
    if t[0] == 'in':
        return t[1]
    f, x, y = t[1], t[2], t[3]
    return ev(y if w[ev(f[1], w)] < w[ev(f[2], w)] else x, w)

def dep(t):
    if t[0] == 'in':
        return 0
    if t[0] == 'cmp':
        return 1 + max(dep(t[1]), dep(t[2]))
    return 1 + max(dep(t[1]), dep(t[2]), dep(t[3]))

X = [('in', i) for i in range(n)]
mins = []
for i, k in itertools.combinations(range(n), 2):
    c = ('cmp', X[i], X[k])
    mins.append(('sel', c, X[k], X[i]))     # x_i < x_k ? x_i : x_k  = min
    mins.append(('sel', c, X[i], X[k]))     # max
def mn(i, k):
    return ('sel', ('cmp', X[min(i, k)], X[max(i, k)]), X[max(i, k)], X[min(i, k)]) if True else None
def mx(i, k):
    return ('sel', ('cmp', X[min(i, k)], X[max(i, k)]), X[min(i, k)], X[max(i, k)])
tri = []
if a.tri:
    for i, k, l in itertools.combinations(range(n), 3):
        c = ('cmp', X[i], X[k])
        tri.append(('sel', c, mn(k, l), mn(i, l)))     # x_i < x_k ? min(x_i,x_l) : min(x_k,x_l)
        tri.append(('sel', c, mx(i, l), mx(k, l)))     # x_i < x_k ? max(x_k,x_l) : max(x_i,x_l)
leaves = X + mins + tri
vals = {t: tuple(ev(t, w) for w in W) for t in leaves}
flags = []
for u, v in itertools.permutations(leaves, 2):
    if u[0] == 'sel' and v[0] == 'sel' and not a.big:
        continue                                  # small library: input vs input / input vs min-max
    f = ('cmp', u, v)
    m = 0
    for wi, w in enumerate(W):
        if w[vals[u][wi]] < w[vals[v][wi]]:
            m |= 1 << wi
    if m in (0, FULL):
        continue
    flags.append((dep(f), m, f))
# dedup flags by mask
seen = {}
for d, m, f in sorted(flags, key=lambda x: x[0]):
    seen.setdefault(m, (d, m, f))
flags = sorted(seen.values(), key=lambda x: x[0])
for t in leaves:
    assert all(W[wi][vals[t][wi]] == W[wi][vals[t][wi]] for wi in range(NW))
print('library: %d leaves, %d flags' % (len(leaves), len(flags)), flush=True)

def good_mask(t, j):
    m = 0
    for wi, w in enumerate(W):
        if w[vals[t][wi]] == sorted(w)[j]:
            m |= 1 << wi
    return m

def build(j, D, tlimit=600):
    gm = [(dep(t), good_mask(t, j), t) for t in leaves]
    memo = {}
    t0 = time.time()
    def solve(S, d):
        key = (S, d)
        if key in memo:
            return memo[key]
        for dl_, m, t in gm:
            if dl_ <= d and S & ~m == 0:
                memo[key] = t; return t
        memo[key] = None
        if d <= 1 or time.time() - t0 > tlimit:
            return None
        cands = []
        for fd, m, f in flags:
            if fd > d - 1:
                break
            L = S & m; G = S & ~m
            if L and G:
                cands.append((max(bin(L).count('1'), bin(G).count('1')), L, G, f))
        cands.sort(key=lambda x: x[0])
        for _, L, G, f in cands:
            tl = solve(L, d - 1)
            if tl is None:
                continue
            tg = solve(G, d - 1)
            if tg is None:
                continue
            r = ('sel', f, tg, tl)
            memo[key] = r
            return r
        return None
    r = solve(FULL, D)
    build.timedout = time.time() - t0 > tlimit
    return r

trees = []
for j in ([a.only] if a.only is not None else range(n)):
    t0 = time.time()
    t = build(j, Ds[j], a.tlimit)
    print('output %d depth<=%d: %s (%.0fs%s)' % (j, Ds[j], 'found' if t else 'none', time.time() - t0,
          ', TIME LIMIT' if build.timedout and not t else ''), flush=True)
    if t is None:
        sys.exit(1)
    if a.only is not None:
        print(t); sys.exit(0)
    assert all(W[wi][ev(t, w)] == sorted(w)[j] for wi, w in enumerate(W))
    trees.append(t)
r = compile_dag(trees, Ds, 1, 1)
if r is None:
    print('lsched failed'); sys.exit(1)
body, _, ns = r
prog = [('load', 'P%d' % i, i) for i in range(n)] + body
ok, _ = check(prog, n)
d = {m: depth(prog, LAT[m]) for m in LAT}
k = len(prog) - 2 * n
print('n=%d k=%d %s strict=%s depth U=%d %s E=%d Z2=%d' % (n, k, counts(prog), ok, d['U'][0], d['U'][1], d['E'][0], d['Z2'][0]))
if a.out:
    with open(a.out, 'w') as f:
        f.write('# n=%d R=%d iset=I0 model=out source=latency/dtree2.py (library decision trees) k=%d depthU=%d depthE=%d depthZ2=%d strict=%s\n' % (
            n, n + ns, k, d['U'][0], d['E'][0], d['Z2'][0], ok))
        for op, x, y in prog:
            if op == 'store':
                f.write('out %d, %s\n' % (x, y))
            elif op != 'load':
                f.write('%s %s, %s\n' % (op, x, y))
