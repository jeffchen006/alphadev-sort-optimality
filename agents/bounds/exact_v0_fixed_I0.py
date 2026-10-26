#!/usr/bin/env python3
"""Own exact SAT model of M(n, R, I0) (relaxed: scratch = T = +inf, init flags = eq),
used only to CHECK lower bounds (bounds agent). Not shared with sat/sat2.

Query: exists program of length k, R registers, with #cmp/#cmov/#mov in given ranges?
usage: exact.py n k R [--cmp lo:hi] [--cmov lo:hi] [--mov lo:hi] [--print]
"""
import sys, itertools, argparse
from pysat.formula import CNF, IDPool
from pysat.card import CardEnc, EncType
from pysat.solvers import Solver


def weak_orders(n):
    out = set()
    for t in itertools.product(range(n), repeat=n):
        s = sorted(set(t))
        if s == list(range(len(s))):
            out.add(t)
    return sorted(out)


def build(n, k, R, ranges, perms=False):
    E = [p for p in itertools.permutations(range(n))] if perms else weak_orders(n)
    T = n  # symbol T
    BIG = 10 ** 6
    V = n + 1
    val = lambda e, v: BIG if v == T else e[v]
    pool = IDPool()
    cnf = CNF()
    OPS = ['mov', 'cmp', 'cmovl', 'cmovg']
    op = lambda t, o: pool.id(('op', t, o))
    dst = lambda t, r: pool.id(('d', t, r))
    src = lambda t, r: pool.id(('s', t, r))
    reg = lambda t, e, r, v: pool.id(('x', t, e, r, v))
    lt = lambda t, e: pool.id(('lt', t, e))
    gt = lambda t, e: pool.id(('gt', t, e))
    w = lambda t, e, r: pool.id(('w', t, e, r))
    av = lambda t, e, v: pool.id(('av', t, e, v))
    bv = lambda t, e, v: pool.id(('bv', t, e, v))

    def exactly_one(lits):
        cnf.append(lits)
        for c in CardEnc.atmost(lits, 1, vpool=pool, encoding=EncType.seqcounter).clauses:
            cnf.append(c)

    for t in range(k):
        exactly_one([op(t, o) for o in range(4)])
        exactly_one([dst(t, r) for r in range(R)])
        exactly_one([src(t, r) for r in range(R)])
        for r in range(R):
            cnf.append([-dst(t, r), -src(t, r)])
    # init
    for ei, e in enumerate(E):
        for r in range(R):
            v0 = r if r < n else T
            for v in range(V):
                cnf.append([reg(0, ei, r, v) if v == v0 else -reg(0, ei, r, v)])
        cnf.append([-lt(0, ei)])
        cnf.append([-gt(0, ei)])
    for t in range(k):
        mv, cp, cl, cg = (op(t, o) for o in range(4))
        for ei, e in enumerate(E):
            # flags carry
            cnf.append([cp, -lt(t, ei), lt(t + 1, ei)])
            cnf.append([cp, lt(t, ei), -lt(t + 1, ei)])
            cnf.append([cp, -gt(t, ei), gt(t + 1, ei)])
            cnf.append([cp, gt(t, ei), -gt(t + 1, ei)])
            # cmp operand values
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
            # write predicate
            for r in range(R):
                W = w(t, ei, r)
                cnf.append([-W, dst(t, r)])
                cnf.append([-W, mv, cl, cg])
                cnf.append([-W, -cl, lt(t, ei)])
                cnf.append([-W, -cg, gt(t, ei)])
                cnf.append([-dst(t, r), -mv, W])
                cnf.append([-dst(t, r), -cl, -lt(t, ei), W])
                cnf.append([-dst(t, r), -cg, -gt(t, ei), W])
                for v in range(V):
                    cnf.append([W, -reg(t, ei, r, v), reg(t + 1, ei, r, v)])
                    for s in range(R):
                        if s != r:
                            cnf.append([-W, -src(t, s), -reg(t, ei, s, v), reg(t + 1, ei, r, v)])
                for a, b in itertools.combinations(range(V), 2):
                    cnf.append([-reg(t + 1, ei, r, a), -reg(t + 1, ei, r, b)])
    # --- sound normal form (shortest programs satisfy it; see BOUNDS.md N1-N4) ---
    cnf.append([op(0, 1)])                                   # N1 first instr is cmp
    for t in range(k):
        for r in range(n, R):                                # N4 scratch first-written in index order
            if r > n:
                prev = [dst(u, r - 1) for u in range(t)]
                cnf.append([-dst(t, r), -op(t, 0), -op(t, 2), -op(t, 3)] if False else [-dst(t, r), op(t, 1)] + prev)
    pend = lambda t: pool.id(('pend', t))                    # N2 cmp block has >= 1 cmov
    cnf.append([-pend(0)])
    for t in range(k):
        cm = [op(t, 2), op(t, 3)]
        cnf.append([-op(t, 1), pend(t + 1)])
        cnf.append([-pend(t), op(t, 2), op(t, 3), pend(t + 1)])
        cnf.append([-pend(t), -op(t, 1)])
    cnf.append([-pend(k)])
    cnf.append([dst(k - 1, r) for r in range(n)])            # N3 last instr writes a P register
    # final
    for ei, e in enumerate(E):
        se = sorted(e)
        for j in range(n):
            ok = [v for v in range(n) if e[v] == se[j]]
            cnf.append([reg(k, ei, j, v) for v in ok])
    # counts
    for o, name in [(1, 'cmp'), (2, 'cmov'), (0, 'mov')]:
        if name not in ranges:
            continue
        lo, hi = ranges[name]
        lits = [op(t, o) for t in range(k)] if name != 'cmov' else \
            [op(t, 2) for t in range(k)] + [op(t, 3) for t in range(k)]
        if hi is not None:
            cnf.extend(CardEnc.atmost(lits, hi, vpool=pool, encoding=EncType.seqcounter).clauses)
        if lo is not None and lo > 0:
            cnf.extend(CardEnc.atleast(lits, lo, vpool=pool, encoding=EncType.seqcounter).clauses)
    return cnf, (op, dst, src), OPS


def solve(n, k, R, ranges, perms=False):
    cnf, (op, dst, src), OPS = build(n, k, R, ranges, perms)
    with Solver(name='cadical153', bootstrap_with=cnf.clauses) as s:
        ok = s.solve()
        if not ok:
            return None
        m = set(l for l in s.get_model() if l > 0)
        prog = []
        nm = lambda r: f'P{r}' if r < n else f'S{r - n}'
        for t in range(k):
            o = [i for i in range(4) if op(t, i) in m][0]
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
    ap.add_argument('--perms', action='store_true'); ap.add_argument('--cmp'); ap.add_argument('--cmov'); ap.add_argument('--mov')
    a = ap.parse_args()
    rg = {nm: parse_rng(getattr(a, nm)) for nm in ['cmp', 'cmov', 'mov'] if getattr(a, nm)}
    p = solve(a.n, a.k, a.R, rg, a.perms)
    print('SAT' if p else 'UNSAT', f'n={a.n} k={a.k} R={a.R} perms={a.perms} {rg}')
    if p:
        print('\n'.join(p))
