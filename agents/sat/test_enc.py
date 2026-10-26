"""Cross-check encoder vs simulator: fix a program by assumptions, add ONE order type,
SAT must hold iff sim says the program is correct on that type. Random + network programs."""
import random, sys
from pysat.solvers import Solver
import sim
from encode import Enc


def prog_assumptions(e, prog):
    a = []
    for i, (o, d, s) in enumerate(prog):
        a.append(e.op[i][o]); a.append(e.d[i][d]); a.append(e.s[i][s])
    return a


def net(n, comps):
    p = []
    for a, b in comps:
        p += [('mov', n, a), ('cmp', a, b), ('cmovg', a, b), ('cmovg', b, n)]
    return p


def main(trials=300, seed=1):
    rnd = random.Random(seed)
    nfail = 0
    for n in (3, 4):
        k = 8
        for outmode in ('fixed', 'free', 'snap'):
            for iset in ('I0', 'I1'):
                ops = ['mov', 'cmp', 'cmovl', 'cmovg'] + (['cmovle', 'cmovge'] if iset == 'I1' else [])
                for trial in range(trials // 8):
                    R = n + 3
                    prog = [(rnd.choice(ops), rnd.randrange(R), rnd.randrange(R)) for _ in range(k)]
                    if trial % 3 == 0:  # bias towards sorting-like programs
                        prog = net(n, [(0, 1)])[:k] + prog[4:]
                    for rk in rnd.sample(sim.total_orders(n) if outmode == 'snap' else sim.weak_orders(n), 5):
                        e = Enc(n, k, R, iset, outmode, (), False)
                        e.add_type(rk)
                        s = Solver(name='cadical195', bootstrap_with=e.clauses)
                        got = s.solve(assumptions=prog_assumptions(e, prog))
                        s.delete()
                        if outmode == 'fixed':
                            want = not sim.check_relaxed(prog, n, 'fixed', [rk])
                        else:
                            want = not sim.check_relaxed(prog, n, outmode, [rk])
                        if got != want:
                            nfail += 1
                            print('MISMATCH', n, outmode, iset, prog, rk, got, want)
    # sorting network programs must be SAT with all weak orders (fixed outputs)
    for n, comps in [(3, [(0, 1), (1, 2), (0, 1)]), (4, [(0, 1), (2, 3), (0, 2), (1, 3), (1, 2)])]:
        prog = net(n, comps)
        assert not sim.check_relaxed(prog, n)
        e = Enc(n, len(prog), n + 1, 'I0', 'fixed', (), False)
        for rk in sim.weak_orders(n):
            e.add_type(rk)
        s = Solver(name='cadical195', bootstrap_with=e.clauses)
        ok = s.solve(assumptions=prog_assumptions(e, prog))
        print('network n=%d k=%d encoder SAT: %s' % (n, len(prog), ok))
        nfail += (not ok)
    print('mismatches:', nfail)
    return nfail


if __name__ == '__main__':
    sys.exit(1 if main() else 0)
