"""Build a real I0 program (mov/cmp/cmovl only) from relaxed-DAG solutions (no T),
one per output, by tree unrolling.  Every cmov gets its own destroyable copy of its
D operand and its cmp is re-issued right before it, so the two-address rule and flag
serialisation hold, and the critical path equals the RD depth in model U and model E.

usage: python3 construct.py n D0,D1,...,D{n-1} [--tree] [--cl 1|2] [--model U|E] [--out file.s]
Inputs: P0..P{n-1} (never written).  Output j: the register named in '# out' line
(free-output convention = AlphaDev memory form: stores choose the register).
"""
import sys, os, argparse
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from relax import build, solve
from prog import check, depth, LAT, counts

HERE = os.path.dirname(os.path.abspath(__file__))


def decode(model, vmeta, fmeta):
    pick = lambda sel, idx: idx[[i for i, s in enumerate(sel) if s in model][0]]
    def V(i):
        m = vmeta[i]
        if m[0] == 'in':
            return ('in', m[1])
        _, sF, sA, sB, fidx, vidx = m
        return ('sel', F(pick(sF, fidx)), V(pick(sA, vidx)), V(pick(sB, vidx)))
    def F(i):
        m = fmeta[i]
        if m[0] == 'cmp1':
            return ('cmp', ('in', m[1]), ('in', m[2]))
        _, sA, sB, vidx = m
        return ('cmp', V(pick(sA, vidx)), V(pick(sB, vidx)))
    return V(len(vmeta) - 1)


class Gen:
    def __init__(s, n):
        s.n = n; s.prog = [('load', 'P%d' % i, i) for i in range(n)]; s.ns = 0; s.cache = {}
    def fresh(s):
        s.ns += 1; return 'S%d' % (s.ns - 1)
    def own(s, t):
        """register with a destroyable copy of tree t"""
        if t[0] == 'in':
            r = s.fresh(); s.prog.append(('mov', r, 'P%d' % t[1])); return r
        _, f, a, b = t
        if a == b:   # sel(f, a, a) = a: pass-through
            return s.own(a)
        ra = s.own(a)
        rb = s.read(b)
        ca, cb = s.read(f[1]), s.read(f[2])
        s.prog.append(('cmp', ca, cb))
        s.prog.append(('cmovl', ra, rb))
        return ra
    def read(s, t):
        """register holding tree t, never destroyed later"""
        if t[0] == 'in':
            return 'P%d' % t[1]
        if t not in s.cache:
            s.cache[t] = s.own(t)
        return s.cache[t]


class Gen2:
    """sharing compiler: each distinct subtree is computed once into a register that is never
    destroyed; a destroyed (cmov D) operand is a mov copy when the copy does not raise the depth,
    else a recomputation; a subtree with a single use is computed in place."""
    def __init__(s, n, movlat, cl):
        s.n = n; s.prog = [('load', 'P%d' % i, i) for i in range(n)]; s.ns = 0
        s.cache = {}; s.uses = {}; s.movlat = movlat; s.cl = cl; s.dm = {}
    def fresh(s):
        s.ns += 1; return 'S%d' % (s.ns - 1)
    def depth(s, t):
        if t[0] == 'in':
            return 0
        if t not in s.dm:
            f, a, b = t[1], t[2], t[3]
            if a == b:
                s.dm[t] = s.depth(a)
            else:
                s.dm[t] = 1 + max(s.cl + max(s.depth(f[1]), s.depth(f[2])), s.depth(a), s.depth(b))
        return s.dm[t]
    def count(s, t):
        s.uses[t] = s.uses.get(t, 0) + 1
        if s.uses[t] > 1 or t[0] == 'in':
            return
        f, a, b = t[1], t[2], t[3]
        if a == b:
            s.count(a); return
        for x in (a, b, f[1], f[2]):
            s.count(x)
    def read(s, t):
        if t[0] == 'in':
            return 'P%d' % t[1]
        if t not in s.cache:
            s.cache[t] = s.compute(t)
        return s.cache[t]
    def own(s, t, parent_depth):
        if t[0] == 'in':
            r = s.fresh(); s.prog.append(('mov', r, 'P%d' % t[1])); return r
        if s.uses[t] == 1 and t not in s.cache:
            return s.compute(t)
        if t in s.cache or s.depth(t) + s.movlat <= parent_depth - 1:
            src = s.read(t)
            if s.depth(t) + s.movlat <= parent_depth - 1:
                r = s.fresh(); s.prog.append(('mov', r, src)); return r
        return s.compute(t)
    def compute(s, t):
        f, a, b = t[1], t[2], t[3]
        if a == b:
            return s.own(a, s.depth(t) + 1)
        d = s.depth(t)
        ra = s.own(a, d)
        rb = s.read(b)
        ca, cb = s.read(f[1]), s.read(f[2])
        s.prog.append(('cmp', ca, cb))
        s.prog.append(('cmovg' if len(t) > 4 and t[4] else 'cmovl', ra, rb))
        return ra


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('n', type=int); ap.add_argument('D')
    ap.add_argument('--out', default=None)
    ap.add_argument('--cl', type=int, default=1, help='cmp latency of the RD search (2 = Z2)')
    ap.add_argument('--tree', action='store_true', help='plain tree unrolling (no sharing)')
    ap.add_argument('--model', default='U', help='latency model the sharing compiler must keep (U: copies cost 1)')
    a = ap.parse_args()
    n = a.n
    Ds = [int(x) for x in a.D.split(',')]
    if len(Ds) == 1:
        Ds = Ds * n
    trees = []
    for j in range(n):
        cnf, stats, vm, fm = build(n, j, Ds[j], useT=False, cl=a.cl)
        sat, model = solve(cnf, os.path.join(HERE, '../../bin/kissat'),
                           os.path.join(HERE, 'cnf', 'con_%d_%d_%d.cnf' % (n, j, os.getpid())))
        os.remove(os.path.join(HERE, 'cnf', 'con_%d_%d_%d.cnf' % (n, j, os.getpid())))
        if not sat:
            print('output %d: no T-free RD DAG of depth %d' % (j, Ds[j])); return
        trees.append(decode(model, vm, fm))
    if a.tree:
        g = Gen(n)
        outs = [g.own(t) for t in trees]
    else:
        g = Gen2(n, 1 if a.model == 'U' else 0, a.cl)
        for t in trees:
            g.count(t); g.uses[t] += 1          # output use: keep the root
        outs = [g.read(t) for t in trees]
    prog = g.prog + [('store', j, outs[j]) for j in range(n)]
    ok, cex = check(prog, n)
    dU = depth(prog, LAT['U']); dE = depth(prog, LAT['E']); dZ = depth(prog, LAT['Z2'])
    c = counts(prog)
    k = len(prog) - 2 * n
    print('n=%d strict-correct=%s k=%d counts=%s depthU=%d %s depthE=%d %s depthZ2=%d %s' % (
        n, ok, k, c, dU[0], dU[1], dE[0], dE[1], dZ[0], dZ[1]))
    if a.out:
        with open(a.out, 'w') as f:
            f.write('# n=%d R=%d iset=I0 model=out source=latency/construct.py RD-depths=%s cl=%d k=%d depthU=%d depthE=%d depthZ2=%d strict=%s\n' % (
                n, n + g.ns, a.D, a.cl, k, dU[0], dE[0], dZ[0], ok))
            for op, d, s in prog:
                if op == 'store':
                    f.write('out %d, %s\n' % (d, s))
                elif op != 'load':
                    f.write('%s %s, %s\n' % (op, d, s))

if __name__ == '__main__':
    main()
