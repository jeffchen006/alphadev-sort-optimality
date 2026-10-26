"""CEGIS driver: SAT on a growing set of order types (pysat CaDiCaL 1.9.5, incremental).
UNSAT on a subset => UNSAT for all order types. SAT => check the program on all weak orders with sim.py;
a failing order type is added as counterexample."""
import argparse, random, sys, time, json
from pysat.solvers import Solver
import sim
from encode import Enc, ALL_RULES


def cegis(n, k, R=None, iset='I0', outmode='fixed', rules=(), nop=False, init=None, seed=0, log=print,
          solver='cadical195', maxtypes=10 ** 9, mincmp=0, mincmov=0):
    t0 = time.time()
    e = Enc(n, k, R, iset, outmode, rules, nop, mincmp, mincmov)
    rnd = random.Random(seed)
    allw = sim.weak_orders(n)
    init = init if init is not None else [tuple(range(n)), tuple(range(n - 1, -1, -1))]
    s = Solver(name=solver)
    pushed = 0
    for t in init:
        e.add_type(t)
    it = 0
    while True:
        for c in e.clauses[pushed:]:
            s.add_clause(c)
        pushed = len(e.clauses)
        it += 1
        r = s.solve()
        log('  iter %d types %d vars %d clauses %d -> %s (%.1fs)' % (it, len(e.types), e.nvars, len(e.clauses),
                                                                    'SAT' if r else 'UNSAT', time.time() - t0))
        if not r:
            s.delete()
            return {'result': 'UNSAT', 'types': e.types, 'enc': e, 'time': time.time() - t0}
        prog, outmap = e.decode(s.get_model())
        bad = sim.check_relaxed(prog, n, outmode, allw, outmap)
        if not bad:
            s.delete()
            return {'result': 'SAT', 'prog': prog, 'outmap': outmap, 'types': e.types, 'enc': e,
                    'time': time.time() - t0}
        if len(e.types) >= maxtypes:
            s.delete()
            return {'result': 'UNKNOWN', 'types': e.types, 'enc': e, 'time': time.time() - t0}
        e.add_type(rnd.choice(bad))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('-n', type=int, required=True)
    ap.add_argument('-k', type=int, required=True)
    ap.add_argument('-R', type=int, default=None)
    ap.add_argument('--iset', default='I0', choices=['I0', 'I1'])
    ap.add_argument('--outmode', default='fixed', choices=["fixed", "free", "snap"])
    ap.add_argument('--rules', default='', help='comma list of %s or "all"' % ','.join(ALL_RULES))
    ap.add_argument('--nop', action='store_true')
    ap.add_argument('--seed', type=int, default=0)
    ap.add_argument('--mincmp', type=int, default=0)
    ap.add_argument('--mincmov', type=int, default=0)
    ap.add_argument('--types', default='', help='init types: perm = all permutations')
    ap.add_argument('--cnf', help='write final CNF (the counterexample subset) here')
    ap.add_argument('--prog', help='write found program here')
    a = ap.parse_args()
    rules = [r for r in ALL_RULES if a.outmode != 'fixed' or r != 'pcanon'] if a.rules == 'all' else [r for r in a.rules.split(',') if r]
    init = sim.total_orders(a.n) if a.types == 'perm' else None
    res = cegis(a.n, a.k, a.R, a.iset, a.outmode, rules, a.nop, init=init, seed=a.seed, mincmp=a.mincmp, mincmov=a.mincmov)
    e = res['enc']
    desc = 'n=%d k=%d R=%d iset=%s outmode=%s rules=%s nop=%s mincmp=%d mincmov=%d' % (
        a.n, a.k, e.R, a.iset, a.outmode, ','.join(rules) or '-', a.nop, a.mincmp, a.mincmov)
    print('RESULT', res['result'], desc, 'types=%d' % len(res['types']), 'time=%.1fs' % res['time'])
    print('TYPES', json.dumps(res['types']))
    if a.cnf:
        e.dimacs(a.cnf, desc + '\ntypes=' + json.dumps(res['types']))
    if res['result'] == 'SAT':
        prog = res['prog']
        hdr = '# n=%d R=%d iset=%s source=sat/cegis.py %s outmap=%s' % (a.n, e.R, a.iset, desc, res['outmap'])
        txt = sim.fmt(prog, a.n, hdr)
        print(txt)
        if a.outmode == 'fixed':
            ok, exact = sim.check_strict([p for p in prog if p[0] != 'nop'], a.n)
            print('strict check:', ok, 'exact' if exact else 'tested(taint)')
        if a.prog:
            open(a.prog, 'w').write(txt)


if __name__ == '__main__':
    main()
