"""Joint relaxed DAG with a size budget: lower bound on program LENGTH at depth <= D (latency agent).

One RD DAG computes all n outputs (output j at depth <= D_j).  A sel node may test lt or gt of
its flag node (cmovg = cmovl on the swapped cmp), so one real cmp gives one flag node.
Map from a real I1 program P (T-relaxed, any output rule) of depth <= D: as in RULES_LATENCY.md A1;
distinct sel functions <= #cmov(P), distinct non-constant flag functions (up to orientation) <= #cmp(P).
So: no joint DAG with <= K used nodes  ==>  every program of depth <= D has #cmp + #cmov >= K+1,
hence length k >= K+1 (movs not counted).
Width per layer: sum over outputs of relax.widths (union of the per-output trees).

usage: python3 relax_joint.py n D0,..,D{n-1} K [--T] [--cl 1|2]     (SAT: a DAG with <= K nodes exists)
       python3 relax_joint.py n D0,..,D{n-1} min [--T] [--cl c]     (find the minimum K)
"""
import sys, os, argparse, itertools
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from relax import CNF, widths, order, solve
from prog import weak_orders
from pysat.card import CardEnc, EncType

HERE = os.path.dirname(os.path.abspath(__file__))


def build_joint(n, Ds, K, useT=True, cl=1, W=None, movs=False, iset='I1'):
    if W is None:
        W = weak_orders(n)
    vals = list(range(n)) + (['T'] if useT else [])
    rank = lambda w, c: (n + 1) if c == 'T' else w[c]
    cnf = CNF()
    D = max(Ds)
    Wv = {}; Wf = {}
    for Dj in Ds:
        a, b = widths(Dj, cl)
        for l in range(D + 1):
            Wv[l] = Wv.get(l, 0) + a.get(l, 0); Wf[l] = Wf.get(l, 0) + b.get(l, 0)
    vnodes = []; fnodes = []   # (layer, table, used-literal or None)
    vmeta = []; fmeta = []
    for c in vals:
        vnodes.append((0, [{d: (d == c) for d in vals} for w in W], None)); vmeta.append(('in', c))
    cost = []
    destroy = {}
    for i in range(n):
        for k in range(i + 1, n):
            u = cnf.var(); cost.append(u)
            fnodes.append((cl, [w[i] < w[k] for w in W], [w[i] > w[k] for w in W], u)); fmeta.append(('cmp1', i, k))

    def mux_value(cands, wi, sel):
        row = {c: cnf.var() for c in vals}
        cnf.at_most_one(row.values())
        for s, (lay, tab, _) in zip(sel, cands):
            for c in vals:
                x = tab[wi][c]
                if x is True:
                    cnf.add([-s, row[c]])
                elif x is not False:
                    cnf.add([-s, -x, row[c]])
        return row

    def lit(cnf, x):
        return x

    for l in range(cl + 1, D + 1):
        nv = Wv[l]
        nf = 0 if l <= cl + 1 or l == D else Wf[l]
        gidx = [i for i, x in enumerate(vnodes) if x[0] <= l - cl]
        vidx = [i for i, x in enumerate(vnodes) if x[0] < l]
        fidx = [i for i, x in enumerate(fnodes) if x[0] < l]
        gc = [vnodes[i] for i in gidx]; vc = [vnodes[i] for i in vidx]; fc = [fnodes[i] for i in fidx]
        newv = []; prevF = None; prevu = None
        for _ in range(nv):
            u = cnf.var(); cost.append(u)
            sF = [cnf.var() for _ in fc]; cnf.exactly_one(sF)
            pol = cnf.var()            # False: test lt, True: test gt
            sA = [cnf.var() for _ in vc]; cnf.exactly_one(sA)
            sB = [cnf.var() for _ in vc]; cnf.exactly_one(sB)
            # symmetry: used nodes first, in flag order; unused nodes have fixed choices
            if prevu is not None:
                cnf.add([-u, prevu])
                for x in range(len(sF)):
                    for y in range(x + 1, len(prevF)):
                        cnf.add([-u, -prevF[y], -sF[x]])
            prevF = sF; prevu = u
            cnf.add([u, sF[0]]); cnf.add([u, sA[0]]); cnf.add([u, sB[1]]); cnf.add([u, -pol])
            for x, y in zip(sA, sB):
                cnf.add([-x, -y])      # no pass-through (roots/children may use any lower layer)
            # used propagation
            for s, (_, _, *rest) in zip(sF, fc):
                cnf.add([-u, -s, rest[-1]])
            for s, nd in zip(sA, vc):
                if nd[2] is not None:
                    cnf.add([-u, -s, nd[2]])
            for s, nd in zip(sB, vc):
                if nd[2] is not None:
                    cnf.add([-u, -s, nd[2]])
            tab = []
            for wi, w in enumerate(W):
                row = {c: cnf.var() for c in vals}; cnf.exactly_one(row.values())
                A = mux_value(vc, wi, sA); B = mux_value(vc, wi, sB)
                C = cnf.var()          # condition true
                for s, fn in zip(sF, fc):
                    ltv, gtv = fn[1][wi], fn[2][wi]
                    for p, xv in ((False, ltv), (True, gtv)):
                        pl = pol if p else -pol
                        if xv is True:
                            cnf.add([-s, -pl, C])
                        elif xv is False:
                            cnf.add([-s, -pl, -C])
                        else:
                            cnf.add([-s, -pl, -xv, C]); cnf.add([-s, -pl, xv, -C])
                for c in vals:
                    cnf.add([-C, -B[c], row[c]]); cnf.add([C, -A[c], row[c]])
                tab.append(row)
            if movs:
                # holder count: this sel destroys one holder of its D operand (a; in I1 a or b: cmovle/ge)
                dsel = cnf.var() if iset == 'I1' else None
                for ci, x, y in zip(vidx, sA, sB):
                    dl_ = cnf.var(); destroy.setdefault(ci, []).append(dl_)
                    cnf.add([-u, -x, dl_] + ([dsel] if dsel else []))
                    if dsel:
                        cnf.add([-u, -y, -dsel, dl_])
            newv.append((l, tab, u)); vmeta.append(('sel', sF, pol, sA, sB, fidx, vidx))
        newf = []; prevA = None; prevu = None
        for _ in range(nf):
            u = cnf.var(); cost.append(u)
            sA = [cnf.var() for _ in gc]; cnf.exactly_one(sA)
            sB = [cnf.var() for _ in gc]; cnf.exactly_one(sB)
            if prevu is not None:
                cnf.add([-u, prevu])
                for x in range(len(sA)):
                    for y in range(x + 1, len(prevA)):
                        cnf.add([-u, -prevA[y], -sA[x]])
            prevA = sA; prevu = u
            cnf.add([u, sA[0]]); cnf.add([u, sB[0]])
            for s, nd in zip(sA, gc):
                if nd[2] is not None:
                    cnf.add([-u, -s, nd[2]])
            for s, nd in zip(sB, gc):
                if nd[2] is not None:
                    cnf.add([-u, -s, nd[2]])
            lts = []; gts = []
            for wi, w in enumerate(W):
                A = mux_value(gc, wi, sA); B = mux_value(gc, wi, sB)
                lt, gt = cnf.var(), cnf.var()
                for c in vals:
                    for d in vals:
                        cnf.add([-A[c], -B[d], lt if rank(w, c) < rank(w, d) else -lt])
                        cnf.add([-A[c], -B[d], gt if rank(w, c) > rank(w, d) else -gt])
                lts.append(lt); gts.append(gt)
            newf.append((l, lts, gts, u)); fmeta.append(('cmp', sA, sB, gidx))
        vnodes += newv; fnodes += newf
    # roots
    roots = []
    for j in range(n):
        cidx = [i for i, x in enumerate(vnodes) if 0 < x[0] <= Ds[j]]
        cands = [vnodes[i] for i in cidx]
        r = [cnf.var() for _ in cands]; cnf.exactly_one(r)
        roots.append((r, cidx))
        for s, (lay, tab, u) in zip(r, cands):
            cnf.add([-s, u])
            for wi, w in enumerate(W):
                tgt = sorted(w)[j]
                for c in vals:
                    if c == 'T' or w[c] != tgt:
                        cnf.add([-s, -tab[wi][c]])
    extra = 0
    if movs:
        # sum_c max(0, #destroyers(c) - 1) = sum_c #destroyers(c) - #(c with a destroyer)
        for c, L in destroy.items():
            nz = cnf.var(); cnf.add([-nz] + L)
            cost += L + [-nz]; extra += 1
    if K is not None:
        enc = CardEnc.atmost(lits=cost, bound=K + extra, top_id=cnf.nv, encoding=EncType.seqcounter)
        cnf.nv = max(cnf.nv, enc.nv)
        for c in enc.clauses:
            cnf.add(c)
    cnf.meta = (vmeta, fmeta, roots)
    return cnf, Wv, Wf, len(cost)


def decode_joint(model, meta):
    """trees ('sel', f, a, b, pol) / ('in', c); f = ('cmp', a, b); pol True = test gt"""
    vmeta, fmeta, roots = meta
    pick = lambda sel, idx: idx[[i for i, s in enumerate(sel) if s in model][0]]
    def V(i):
        m = vmeta[i]
        if m[0] == 'in':
            return ('in', m[1])
        _, sF, pol, sA, sB, fidx, vidx = m
        return ('sel', F(pick(sF, fidx)), V(pick(sA, vidx)), V(pick(sB, vidx)), pol in model)
    def F(i):
        m = fmeta[i]
        if m[0] == 'cmp1':
            return ('cmp', ('in', m[1]), ('in', m[2]))
        _, sA, sB, gidx = m
        return ('cmp', V(pick(sA, gidx)), V(pick(sB, gidx)))
    return [V(pick(r, cidx)) for r, cidx in roots]


if __name__ == '__main__':
    ap = argparse.ArgumentParser()
    ap.add_argument('n', type=int); ap.add_argument('D'); ap.add_argument('K')
    ap.add_argument('--T', action='store_true'); ap.add_argument('--cl', type=int, default=1)
    ap.add_argument('--cnf', default=None); ap.add_argument('--proof', default=None)
    ap.add_argument('--solver', default=os.path.join(HERE, '../../bin/kissat'))
    ap.add_argument('--movs', action='store_true', help='count extra holders (movs / repeated cmovs) of destroyed operands')
    ap.add_argument('--iset', default='I1')
    ap.add_argument('--perm', action='store_true', help='only the n! permutations (subset of order types: sound for UNSAT, L1b)')
    a = ap.parse_args()
    Ds = [int(x) for x in a.D.split(',')]
    if len(Ds) == 1:
        Ds = Ds * a.n
    Ks = range(1, 200) if a.K == 'min' else [int(a.K)]
    for K in Ks:
        Wsub = [w for w in weak_orders(a.n) if len(set(w)) == a.n] if a.perm else None
        cnf, Wv, Wf, nc = build_joint(a.n, Ds, K, a.T, a.cl, Wsub, a.movs, a.iset)
        path = a.cnf or os.path.join(HERE, 'cnf', 'joint_%d_%d.cnf' % (a.n, os.getpid()))
        sat, _ = solve(cnf, a.solver, path, a.proof)
        print('joint%s%s n=%d D=%s cl=%d T=%s K=%d (nodes avail %d, vars %d, clauses %d): %s' % (
            ' perm' if a.perm else '', ' movs(%s)' % a.iset if a.movs else '', a.n, Ds, a.cl, a.T, K, nc, cnf.nv, len(cnf.cl), 'SAT' if sat else 'UNSAT'), flush=True)
        if not a.cnf:
            os.remove(path)
        if sat:
            break
