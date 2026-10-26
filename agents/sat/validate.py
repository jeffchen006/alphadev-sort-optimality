"""Rule validation: minimal k must not change when a rule is switched on/off.
usage: validate.py n kmax iset outmode types(perm|all) timeout_s
Runs, for rule sets {none, all, all-minus-r, only-r}, k = 0..kmax with pysat cadical195 (full instance), prints min k."""
import sys, time, multiprocessing as mp
from pysat.solvers import Solver
from encode import Enc, ALL_RULES
import sim

DEP = {'pcanon': [], 'dead': [], 'flags': [], 'cmpord': [], 'movfresh': ['canon'], 'snapcmov': [],
       'hcmp': ['flags', 'snapcmov'], 'canon': [], 'comm': []}


def valid(rules, outmode):
    rs = set(rules)
    if outmode == 'fixed' and rs & {'pcanon', 'movfresh', 'snapcmov', 'hcmp'}:
        return False
    if outmode == 'free' and rs & {'snapcmov', 'hcmp'}:
        return False
    return all(set(DEP[r]) <= rs for r in rs)


def run(args):
    n, k, iset, outmode, rules, tt = args
    nop = bool(set(rules) - {'canon', 'pcanon', 'comm', 'snapcmov'})
    e = Enc(n, k, None, iset, outmode, rules, nop)
    for t in (sim.total_orders(n) if tt == 'perm' else sim.weak_orders(n)):
        e.add_type(t)
    if 'hcmp' in rules:
        if tt != 'perm':
            return None
        e.add_class_cuts()
    s = Solver(name='cadical195', bootstrap_with=e.clauses)
    r = s.solve()
    if r:
        prog, outmap = e.decode(s.get_model())
        assert not sim.check_relaxed(prog, n, outmode, sim.weak_orders(n) if tt == 'all' else sim.total_orders(n), outmap)
    s.delete()
    return r


def minimal_k(n, kmax, iset, outmode, rules, tt, pool):
    """(each k in its own process; with SETS='all-*' and KS=10 this is the UNSAT side of the rule check)"""
    import os
    ks = [int(x) for x in os.environ['KS'].split(',')] if os.environ.get('KS') else list(range(1, kmax + 1))
    rs = pool.map(run, [(n, k, iset, outmode, rules, tt) for k in ks])
    sat = [k for k, r in zip(ks, rs) if r]
    return (min(sat) if sat else None), rs


def main():
    n, kmax, iset, outmode, tt = int(sys.argv[1]), int(sys.argv[2]), sys.argv[3], sys.argv[4], sys.argv[5]
    allr = [r for r in ALL_RULES if valid([r] + DEP[r], outmode) and (tt == 'perm' or r != 'hcmp')]
    sets = {'none': [], 'all': allr}
    for r in allr:
        rest = [x for x in allr if x != r and r not in DEP[x]]
        sets['all-' + r] = rest
        sets['only-' + r] = [r] + DEP[r]
    pool = mp.Pool(int(sys.argv[6]) if len(sys.argv) > 6 else 4)
    out = {}
    import os, fnmatch
    if os.environ.get('PARSETS'):
        pat = os.environ.get('SETS', '*')
        ks = [int(x) for x in os.environ['KS'].split(',')]
        jobs = [(name, k) for name, rules in sets.items() if valid(rules, outmode) and fnmatch.fnmatch(name, pat) for k in ks]
        res = pool.map(run, [(n, k, iset, outmode, sets[name], tt) for name, k in jobs])
        for (name, k), r in zip(jobs, res):
            print('%-14s k=%d %s' % (name, k, 'SAT' if r else 'UNSAT'), flush=True)
        return
    pat = os.environ.get('SETS', '*')
    for name, rules in sets.items():
        if not valid(rules, outmode) or not fnmatch.fnmatch(name, pat):
            continue
        t0 = time.time()
        mk, rs = minimal_k(n, kmax, iset, outmode, rules, tt, pool)
        out[name] = mk
        # monotone check: no SAT below min k, every k >= min k SAT (nop mode / padding)
        print('%-14s min k = %s   pattern %s   (%.1fs)' % (name, mk, ''.join('S' if r else ('U' if r is not None else '?') for r in rs),
                                                     time.time() - t0), flush=True)
    vals = set(v for v in out.values())
    print('n=%d iset=%s outmode=%s types=%s: %s' % (n, iset, outmode, tt, 'AGREE min k = %s' % vals.pop() if len(vals) == 1 else 'DISAGREE %s' % out))


if __name__ == '__main__':
    main()
