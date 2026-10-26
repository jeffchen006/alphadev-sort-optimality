"""Solve one full instance (all permutations or all weak orders) with pysat; on SAT decode, check with sim
(all weak orders) and write a judge-format file (model=out). usage: solve_full.py n k iset outmode rules types(perm|all) [out.s]"""
import sys, time
from pysat.solvers import Solver
from encode import Enc, ALL_RULES
import sim


def to_out_file(prog, outmap, n, hdr):
    """snap outmap (time, reg) -> 'out j, REG' lines placed right after step time-1."""
    lines = [hdr]
    after = {}
    for j, (t, r) in enumerate(outmap):
        after.setdefault(t, []).append((j, r))
    for j, r in after.get(0, []):
        lines.append('out %d, %s' % (j, sim.reg_name(r, n)))
    for i, (op, d, s) in enumerate(prog):
        if op != 'nop':
            lines.append('%s %s, %s' % (op, sim.reg_name(d, n), sim.reg_name(s, n)))
        for j, r in after.get(i + 1, []):
            lines.append('out %d, %s' % (j, sim.reg_name(r, n)))
    return '\n'.join(lines) + '\n'


def main():
    n, k, iset, outmode, rules, tt = int(sys.argv[1]), int(sys.argv[2]), sys.argv[3], sys.argv[4], sys.argv[5], sys.argv[6]
    rules = [r for r in rules.split(',') if r and r != '-']
    nop = bool(set(rules) - {'canon', 'pcanon', 'comm', 'snapcmov'})
    e = Enc(n, k, None, iset, outmode, rules, nop)
    types = sim.total_orders(n) if tt == 'perm' else sim.weak_orders(n)
    for t in types:
        e.add_type(t)
    if 'hcmp' in rules:
        e.add_class_cuts()
    t0 = time.time()
    s = Solver(name='cadical195', bootstrap_with=e.clauses)
    r = s.solve()
    print('RESULT', 'SAT' if r else 'UNSAT', 'n=%d k=%d R=%d %s %s rules=%s nop=%s types=%s %.1fs' % (
        n, k, e.R, iset, outmode, ','.join(rules), nop, tt, time.time() - t0))
    if r:
        prog, outmap = e.decode(s.get_model())
        real = [p for p in prog if p[0] != 'nop']
        bad = sim.check_relaxed(prog, n, outmode, sim.weak_orders(n), outmap)
        print('relaxed check on all %d weak orders: %s' % (len(sim.weak_orders(n)), 'OK' if not bad else 'FAIL %s' % bad[:3]))
        hdr = '# n=%d R=%d iset=%s model=out source=agents/sat/solve_full.py k=%d rules=%s types=%s' % (
            n, e.R, iset, len(real), ','.join(rules) or '-', tt)
        txt = to_out_file(prog, outmap, n, hdr) if outmode == 'snap' else sim.fmt(prog, n, hdr)
        print(txt)
        if len(sys.argv) > 7:
            open(sys.argv[7], 'w').write(txt)


if __name__ == '__main__':
    main()
