"""Relaxed-DAG depth lower bound (latency agent, own encoding).

Relaxed model RD(n, D): a DAG of
  flag node  f = cmp(a, b)          f(w) = lt  iff a(w) < b(w)
  value node v = sel(f, a, b)       v(w) = b(w) if f(w)=lt else a(w)
each of latency 1, inputs x_0..x_{n-1} (and optionally T = garbage, larger than every
input) at depth 0.  No two-address rule, no flag-serialisation rule, mov free, sharing
free.  Every real program of I1 (mov/cmp/cmovl/cmovg/cmovle/cmovge) with unit cmp/cmov
latency (mov latency 0 or 1) maps to an RD DAG of depth <= its critical path
(cmovg = cmovl on the swapped cmp, cmovle/cmovge = cmovg/cmovl with a, b swapped).
So: no RD DAG of depth D computes output j  ==>  no real program has depth <= D.
Outputs are independent in RD (sharing is free), so we search one output at a time.

SAT: one value node at layer D (root).  Layer l holds at most W_l value nodes and U_l flag
nodes (W_l, U_l = max number of depth-l nodes in any tree of root depth D, see widths()).
Children of a layer-l node lie in layers < l.  Layer-1 flags are the constants
cmp(x_i, x_j); layer-1 values are copies of inputs (flags at depth 0 are constant) so are
omitted; layer-2 flags equal layer-1 flags so are omitted.  Each node is evaluated on every
weak order type w of the n inputs.

usage: python3 relax.py n j D [--T] [--cnf out.cnf] [--solver kissat]
"""
import itertools, subprocess, sys, os, argparse
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from prog import weak_orders


class CNF:
    def __init__(s):
        s.nv = 0; s.cl = []
    def var(s):
        s.nv += 1; return s.nv
    def add(s, c):
        s.cl.append(c)
    def exactly_one(s, xs):
        s.add(list(xs))
        s.at_most_one(xs)
    def at_most_one(s, xs):
        xs = list(xs)
        if len(xs) <= 6:
            for a, b in itertools.combinations(xs, 2):
                s.add([-a, -b])
        else:  # sequential counter
            prev = None
            for i, x in enumerate(xs):
                if i < len(xs) - 1:
                    r = s.var()
                    s.add([-x, r])
                    if prev:
                        s.add([-prev, r]); s.add([-prev, -x])
                    prev = r
                else:
                    s.add([-prev, -x])
    def dimacs(s, path):
        with open(path, 'w') as f:
            f.write('p cnf %d %d\n' % (s.nv, len(s.cl)))
            for c in s.cl:
                f.write(' '.join(map(str, c)) + ' 0\n')


def widths(D, cl=1):
    """Wv[l], Wf[l]: max # value / flag nodes of depth exactly l in a tree whose value root
    has depth D.  A value node of depth d has children of depth <= d-1; a flag node of depth d
    (cmp latency cl) has value children of depth <= d-cl.  Counts are monotone in depth, so
    the max is reached with children at the largest allowed depth."""
    Wv = {}; Wf = {}
    for l in range(D + 1):
        def count(vroot0, froot0):
            mv = {}; mf = {}
            get = lambda tbl, d: tbl.get(d, 0)
            for d in range(l, D + 1):
                if d == l:
                    mv[d], mf[d] = vroot0, froot0
                else:
                    mv[d] = 2 * get(mv, d - 1) + get(mf, d - 1)
                    mf[d] = 2 * get(mv, d - cl)
            return mv[D]
        Wv[l] = count(1, 0); Wf[l] = count(0, 1)
    return Wv, Wf


def order(cnf, prev, cur):
    """symmetry breaking: index(prev choice) <= index(cur choice); nodes of one layer have the
    same candidate lists, so any permutation of them gives the same DAG (sound)."""
    for x in range(len(cur)):
        for y in range(x + 1, len(prev)):
            cnf.add([-prev[y], -cur[x]])


def build(n, j, D, useT=False, cap=None, W=None, sb=True, cl=1):
    if W is None:
        W = weak_orders(n)
    vals = list(range(n)) + (['T'] if useT else [])
    rank = lambda w, c: (n + 1) if c == 'T' else w[c]
    cnf = CNF()
    Wv, Wf = widths(D, cl)
    if cap:
        for l in Wv:
            Wv[l] = min(Wv[l], cap); Wf[l] = min(Wf[l], cap)
    # value nodes: list of dict(layer, val[w][c] -> literal or True/False constant)
    vnodes = []   # (layer, table) ; table[wi][c] = var id or bool
    fnodes = []   # (layer, table) ; table[wi] = var id or bool (lt)
    vmeta = []; fmeta = []   # decode info: ('in', c) | ('sel', sF, sA, sB, fidx, vidx) ; ('cmp1', i, k) | ('cmp', sA, sB, vidx)
    for c in vals:
        vnodes.append((0, [{d: (d == c) for d in vals} for w in W])); vmeta.append(('in', c))
    for i in range(n):
        for k in range(n):
            if i != k:
                fnodes.append((cl, [w[i] < w[k] for w in W])); fmeta.append(('cmp1', i, k))
    nconst_v = len(vnodes)

    def lit_true(x):
        return x is True
    def new_value_table():
        t = []
        for wi in range(len(W)):
            row = {c: cnf.var() for c in vals}
            cnf.exactly_one(row.values())
            t.append(row)
        return t

    def mux_value(cands, wi, sel):
        """returns dict c -> var  for the value of the selected candidate at w."""
        row = {c: cnf.var() for c in vals}
        cnf.at_most_one(row.values())
        for s, (lay, tab) in zip(sel, cands):
            for c in vals:
                x = tab[wi][c]
                if x is True:
                    cnf.add([-s, row[c]])
                elif x is False:
                    continue
                else:
                    cnf.add([-s, -x, row[c]])
        return row

    stats = {}
    for l in range(cl + 1, D + 1):
        nv = 1 if l == D else Wv[l]
        nf = 0 if (l == D or l <= cl + 1) else Wf[l]
        gidx = [i for i, x in enumerate(vnodes) if x[0] <= l - cl]   # value children of flags
        gc = [vnodes[i] for i in gidx]
        vidx = [i for i, x in enumerate(vnodes) if x[0] < l]
        fidx = [i for i, x in enumerate(fnodes) if x[0] < l]
        vc = [vnodes[i] for i in vidx]
        fc = [fnodes[i] for i in fidx]
        stats[l] = (nv, nf, len(vc), len(fc))
        newv = []
        prevF = None
        for _ in range(nv):
            sF = [cnf.var() for _ in fc]; cnf.exactly_one(sF)
            if sb and prevF is not None:
                order(cnf, prevF, sF)
            prevF = sF
            sA = [cnf.var() for _ in vc]; cnf.exactly_one(sA)
            sB = [cnf.var() for _ in vc]; cnf.exactly_one(sB)
            tab = new_value_table()
            for wi, w in enumerate(W):
                A = mux_value(vc, wi, sA)
                B = mux_value(vc, wi, sB)
                LT = cnf.var()
                for s, (lay, ft) in zip(sF, fc):
                    x = ft[wi]
                    if x is True:
                        cnf.add([-s, LT])
                    elif x is False:
                        cnf.add([-s, -LT])
                    else:
                        cnf.add([-s, -x, LT]); cnf.add([-s, x, -LT])
                for c in vals:
                    cnf.add([-LT, -B[c], tab[wi][c]])
                    cnf.add([LT, -A[c], tab[wi][c]])
            newv.append((l, tab)); vmeta.append(('sel', sF, sA, sB, fidx, vidx))
        newf = []
        prevA = None
        for _ in range(nf):
            sA = [cnf.var() for _ in gc]; cnf.exactly_one(sA)
            if sb and prevA is not None:
                order(cnf, prevA, sA)
            prevA = sA
            sB = [cnf.var() for _ in gc]; cnf.exactly_one(sB)
            tab = []
            for wi, w in enumerate(W):
                A = mux_value(gc, wi, sA)
                B = mux_value(gc, wi, sB)
                lt = cnf.var()
                for c in vals:
                    for d in vals:
                        cnf.add([-A[c], -B[d], lt if rank(w, c) < rank(w, d) else -lt])
                tab.append(lt)
            newf.append((l, tab)); fmeta.append(('cmp', sA, sB, gidx))
        vnodes += newv; fnodes += newf
    root = vnodes[-1][1]
    for wi, w in enumerate(W):
        if callable(j):          # test hook: j(w) = exact required value
            for c in vals:
                if c != j(w):
                    cnf.add([-root[wi][c]])
            continue
        target = sorted(w)[j]
        for c in vals:
            if not (c != 'T' and w[c] == target):
                cnf.add([-root[wi][c]])
    return cnf, stats, vmeta, fmeta


def solve(cnf, solver, path, proof=None):
    cnf.dimacs(path)
    cmd = [solver, '-q', path] if 'kissat' in solver else [solver, '-q', path]
    if proof:
        cmd.append(proof)
        if 'kissat' in solver:
            cmd.insert(1, '--no-binary')
    r = subprocess.run(cmd, capture_output=True, text=True)
    out = r.stdout
    if 's SATISFIABLE' in out:
        model = set()
        for line in out.splitlines():
            if line.startswith('v '):
                model.update(int(x) for x in line[2:].split() if int(x) > 0)
        return True, model
    if 's UNSATISFIABLE' in out:
        return False, None
    raise RuntimeError(out + r.stderr)


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


def evaluate(t, w, n):
    """value (input index or 'T') of tree t on order type w"""
    rk = lambda c: n + 1 if c == 'T' else w[c]
    if t[0] == 'in':
        return t[1]
    _, f, a, b = t
    lt = rk(evaluate(f[1], w, n)) < rk(evaluate(f[2], w, n))
    return evaluate(b if lt else a, w, n)


def cegis(n, j, D, useT, solver, tag, proof=None, cap=None, cl=1, start='perm'):
    """UNSAT on a subset of order types => UNSAT on all (constraints are per order type)."""
    allW = weak_orders(n)
    Wsub = [w for w in allW if len(set(w)) == n]
    if start != 'perm':
        Wsub = Wsub[:2]
    it = 0
    while True:
        it += 1
        cnf, stats, vm, fm = build(n, j, D, useT, cap, Wsub, cl=cl)
        print('  cegis it=%d |W|=%d vars=%d clauses=%d' % (it, len(Wsub), cnf.nv, len(cnf.cl)), flush=True)
        path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'cnf', 'rcg_%s_%d.cnf' % (tag, os.getpid()))
        sat, model = solve(cnf, solver, path)
        if not sat:
            return False, None, it, Wsub, path
        os.remove(path)
        t = decode(model, vm, fm)
        good = lambda w: (lambda v: v != 'T' and w[v] == sorted(w)[j])(evaluate(t, w, n))
        bad = [w for w in allW if not good(w)]
        if not bad:
            return True, t, it, Wsub, None
        Wsub.append(bad[len(bad) // 2])


if __name__ == '__main__':
    ap = argparse.ArgumentParser()
    ap.add_argument('n', type=int); ap.add_argument('j', type=int); ap.add_argument('D', type=int)
    ap.add_argument('--T', action='store_true', help='allow garbage symbol T (lower-bound relaxation)')
    ap.add_argument('--cnf', default=None)
    ap.add_argument('--proof', default=None)
    ap.add_argument('--cap', type=int, default=None, help='cap layer widths (UNSOUND for UNSAT; search only)')
    ap.add_argument('--solver', default=os.path.join(os.path.dirname(os.path.abspath(__file__)), '../../bin/kissat'))
    ap.add_argument('--cegis', action='store_true')
    ap.add_argument('--save-tree', default=None)
    ap.add_argument('--cl', type=int, default=1, help='cmp latency (2 = model Z2)')
    ap.add_argument('--perm', action='store_true', help='only the n! permutations (sound for UNSAT, L1b)')
    a = ap.parse_args()
    if a.cegis:
        import time; t0 = time.time()
        sat, t, it, Wsub, path = cegis(a.n, a.j, a.D, a.T, a.solver, '%d_%d_%d_c%s' % (a.n, a.j, a.D, a.cap), cap=a.cap, cl=a.cl)
        if sat and a.save_tree:
            open(a.save_tree, 'w').write(repr(t) + '\n')
        print('n=%d j=%d D=%d T=%s cegis: %s (it=%d |W|=%d, %.1fs) W=%s' % (a.n, a.j, a.D, a.T,
              'SAT' if sat else 'UNSAT', it, len(Wsub), time.time() - t0, Wsub if not sat else ''))
        if sat:
            print('tree:', t)
        else:
            print('final UNSAT cnf kept:', path)
        sys.exit(0)
    Wsub = [w for w in weak_orders(a.n) if len(set(w)) == a.n] if a.perm else None
    cnf, stats, vn, fn = build(a.n, a.j, a.D, a.T, a.cap, W=Wsub, cl=a.cl)
    path = a.cnf or os.path.join(os.path.dirname(os.path.abspath(__file__)), 'cnf', 'relax_%d_%d_%d_%d.cnf') % (a.n, a.j, a.D, os.getpid())
    sat, model = solve(cnf, a.solver, path, a.proof)
    print('perm=%s cl=%d n=%d j=%d D=%d T=%s cap=%s vars=%d clauses=%d layers(nv,nf,#vcand,#fcand)=%s -> %s' % (
        a.perm, a.cl, a.n, a.j, a.D, a.T, a.cap, cnf.nv, len(cnf.cl), stats, 'SAT' if sat else 'UNSAT'))
    if not a.cnf:
        os.remove(path)
