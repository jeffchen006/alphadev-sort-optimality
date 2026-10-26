#!/usr/bin/env python3
"""Own exact SAT model (bounds agent), used only to CHECK lower bounds. No code shared with sat/sat2.
Model: MODEL.md v1.2, T-relaxed (scratch = T = +inf, cmp(T,T) = eq, initial flags = eq).
  --model out   : M_out, output j = value of register r_j at step t_j (snapshot, chosen by solver)   [default]
  --model fixed : §1, output j = P_j at the end
  --iset I1|I0  : I1 = mov, cmp, cmovl, cmovg, cmovle, cmovge [default]
  --perms       : test only the n! permutations (sound subset, MODEL §3 / L1b)
  --nf          : add normal form N1-N4 (BOUNDS.md §N); sound only in a k-sweep from small k (L4)
Counts: --cmp lo:hi --cmov lo:hi --mov lo:hi
usage: exact.py n k R [opts]
"""
import itertools, argparse
from pysat.formula import CNF, IDPool
from pysat.card import CardEnc, EncType
from pysat.solvers import Solver

OPS_ALL = ['mov', 'cmp', 'cmovl', 'cmovg', 'cmovle', 'cmovge']


def weak_orders(n):
    out = set()
    for t in itertools.product(range(n), repeat=n):
        if sorted(set(t)) == list(range(len(set(t)))):
            out.add(t)
    return sorted(out)


def build(n, k, R, ranges, perms=False, model='out', iset='I1', nf=False):
    E = list(itertools.permutations(range(n))) if perms else weak_orders(n)
    OPS = OPS_ALL if iset == 'I1' else OPS_ALL[:4]
    NO = len(OPS)
    T = n
    V = n + 1
    val = lambda e, v: 10 ** 6 if v == T else e[v]
    pool = IDPool()
    cnf = CNF()
    op = lambda t, o: pool.id(('op', t, o))
    dst = lambda t, r: pool.id(('d', t, r))
    src = lambda t, r: pool.id(('s', t, r))
    reg = lambda t, e, r, v: pool.id(('x', t, e, r, v))
    lt = lambda t, e: pool.id(('lt', t, e))
    gt = lambda t, e: pool.id(('gt', t, e))
    w = lambda t, e, r: pool.id(('w', t, e, r))
    fire = lambda t, e: pool.id(('f', t, e))
    av = lambda t, e, v: pool.id(('av', t, e, v))
    bv = lambda t, e, v: pool.id(('bv', t, e, v))

    def exactly_one(lits):
        cnf.append(lits)
        cnf.extend(CardEnc.atmost(lits, 1, vpool=pool, encoding=EncType.seqcounter).clauses)

    for t in range(k):
        exactly_one([op(t, o) for o in range(NO)])
        exactly_one([dst(t, r) for r in range(R)])
        exactly_one([src(t, r) for r in range(R)])
        for r in range(R):
            cnf.append([-dst(t, r), -src(t, r)])
    for ei, e in enumerate(E):
        for r in range(R):
            v0 = r if r < n else T
            for v in range(V):
                cnf.append([reg(0, ei, r, v) if v == v0 else -reg(0, ei, r, v)])
        cnf.append([-lt(0, ei)])
        cnf.append([-gt(0, ei)])
    for t in range(k):
        cp = op(t, 1)
        for ei, e in enumerate(E):
            L, G = lt(t, ei), gt(t, ei)
            for a, b in [(L, lt(t + 1, ei)), (G, gt(t + 1, ei))]:
                cnf.append([cp, -a, b]); cnf.append([cp, a, -b])
            for r in range(R):
                for v in range(V):
                    cnf.append([-dst(t, r), -reg(t, ei, r, v), av(t, ei, v)])
                    cnf.append([-src(t, r), -reg(t, ei, r, v), bv(t, ei, v)])
            for a, b in itertools.combinations(range(V), 2):
                cnf.append([-av(t, ei, a), -av(t, ei, b)])
                cnf.append([-bv(t, ei, a), -bv(t, ei, b)])
            for va in range(V):
                for vb in range(V):
                    x, y = val(e, va), val(e, vb)
                    cnf.append([-cp, -av(t, ei, va), -bv(t, ei, vb), lt(t + 1, ei) if x < y else -lt(t + 1, ei)])
                    cnf.append([-cp, -av(t, ei, va), -bv(t, ei, vb), gt(t + 1, ei) if x > y else -gt(t + 1, ei)])
            # fire(t,e): instruction t writes its dst on order e
            F = fire(t, ei)
            conds = {2: L, 3: G, 4: -G, 5: -L}
            for o in range(NO):
                if o == 1:
                    cnf.append([-op(t, o), -F])
                elif o == 0:
                    cnf.append([-op(t, o), F])
                else:
                    c = conds[o]
                    cnf.append([-op(t, o), -c, F]); cnf.append([-op(t, o), c, -F])
            for r in range(R):
                W = w(t, ei, r)
                cnf.append([-W, dst(t, r)]); cnf.append([-W, F]); cnf.append([-dst(t, r), -F, W])
                for v in range(V):
                    cnf.append([W, -reg(t, ei, r, v), reg(t + 1, ei, r, v)])
                    for s in range(R):
                        if s != r:
                            cnf.append([-W, -src(t, s), -reg(t, ei, s, v), reg(t + 1, ei, r, v)])
                for a, b in itertools.combinations(range(V), 2):
                    cnf.append([-reg(t + 1, ei, r, a), -reg(t + 1, ei, r, b)])
    # outputs
    outv = lambda j, t, r: pool.id(('out', j, t, r))
    for j in range(n):
        if model == 'fixed':
            cands = [(k, j)]
            cnf.append([outv(j, k, j)])
        else:
            cands = [(t, r) for t in range(1, k + 1) for r in range(R)]
            exactly_one([outv(j, t, r) for t, r in cands])
        for (t, r) in cands:
            for ei, e in enumerate(E):
                se = sorted(e)
                ok = [v for v in range(n) if e[v] == se[j]]
                cnf.append([-outv(j, t, r)] + [reg(t, ei, r, v) for v in ok])
    if nf:
        cnf.append([op(0, 1)])                                        # N1 first instruction is cmp
        pend = lambda t: pool.id(('pend', t))                         # N2 every cmp block has a cmov
        cm = lambda t: [op(t, o) for o in range(2, NO)]
        cnf.append([-pend(0)])
        for t in range(k):
            cnf.append([-op(t, 1), pend(t + 1)])
            cnf.append([-pend(t)] + cm(t) + [pend(t + 1)])
            cnf.append([-pend(t), -op(t, 1)])
        cnf.append([-pend(k)])
        for r in range(R):                                            # N3 last write is an output
            if model == 'fixed':
                if r >= n:
                    cnf.append([-dst(k - 1, r)])
            else:
                cnf.append([-dst(k - 1, r)] + [outv(j, k, r) for j in range(n)])
        for t in range(k):                                            # N4 scratch first-dst order
            for r in range(n + 1, R):
                cnf.append([-dst(t, r)] + [dst(u, r - 1) for u in range(t)])
    for name in ['cmp', 'cmov', 'mov']:
        if name not in ranges:
            continue
        lo, hi = ranges[name]
        os_ = {'mov': [0], 'cmp': [1], 'cmov': list(range(2, NO))}[name]
        lits = [op(t, o) for t in range(k) for o in os_]
        if hi is not None:
            cnf.extend(CardEnc.atmost(lits, hi, vpool=pool, encoding=EncType.seqcounter).clauses)
        if lo:
            cnf.extend(CardEnc.atleast(lits, lo, vpool=pool, encoding=EncType.seqcounter).clauses)
    return cnf, (op, dst, src, outv), OPS


def solve(n, k, R, ranges, **kw):
    cnf, (op, dst, src, outv), OPS = build(n, k, R, ranges, **kw)
    with Solver(name='cadical153', bootstrap_with=cnf.clauses) as s:
        if not s.solve():
            return None
        m = set(l for l in s.get_model() if l > 0)
    nm = lambda r: f'P{r}' if r < n else f'S{r - n}'
    prog = []
    for t in range(k + 1):
        if kw.get('model', 'out') == 'out':
            for j in range(n):
                for r in range(R):
                    if t >= 1 and outv(j, t, r) in m:
                        prog.append(f'out {j}, {nm(r)}')
        if t == k:
            break
        o = [i for i in range(len(OPS)) if op(t, i) in m][0]
        d = [r for r in range(R) if dst(t, r) in m][0]
        sr = [r for r in range(R) if src(t, r) in m][0]
        prog.append(f'{OPS[o]} {nm(d)}, {nm(sr)}')
    return prog


def parse_rng(s):
    lo, hi = s.split(':')
    return (int(lo) if lo else None, int(hi) if hi else None)


if __name__ == '__main__':
    ap = argparse.ArgumentParser()
    ap.add_argument('n', type=int); ap.add_argument('k', type=int); ap.add_argument('R', type=int)
    ap.add_argument('--perms', action='store_true'); ap.add_argument('--nf', action='store_true')
    ap.add_argument('--model', default='out'); ap.add_argument('--iset', default='I1')
    ap.add_argument('--cmp'); ap.add_argument('--cmov'); ap.add_argument('--mov')
    a = ap.parse_args()
    rg = {nm: parse_rng(getattr(a, nm)) for nm in ['cmp', 'cmov', 'mov'] if getattr(a, nm)}
    p = solve(a.n, a.k, a.R, rg, perms=a.perms, model=a.model, iset=a.iset, nf=a.nf)
    print('SAT' if p else 'UNSAT', f'n={a.n} k={a.k} R={a.R} model={a.model} iset={a.iset} perms={a.perms} nf={a.nf} {rg}',
          flush=True)
    if p:
        print(f'# n={a.n} iset={a.iset} model={a.model} source=bounds/exact.py')
        print('\n'.join(p))
