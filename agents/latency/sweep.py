"""Length sweep at a fixed depth: for k = kmin..kmax, is there a program of length k and depth <= D?
Stops at the first SAT. UNSAT answers (also on a CEGIS subset of order types) are final for (k, D, R, iset, out).
usage: python3 sweep.py n D kmin kmax [--model U|E|Z2] [--m M] [--iset I0|I1] [--out snap|free|fixed] [--sb] [--direct]"""
import sys, os, argparse, time
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from regsat import cegis, direct, HERE, full_program, write_s
from prog import check, depth, LAT
ap = argparse.ArgumentParser()
ap.add_argument('n', type=int); ap.add_argument('D', type=int); ap.add_argument('kmin', type=int); ap.add_argument('kmax', type=int)
ap.add_argument('--model', default='U'); ap.add_argument('--m', type=int, default=None)
ap.add_argument('--iset', default='I1'); ap.add_argument('--out', default='snap'); ap.add_argument('--sb', action='store_true')
ap.add_argument('--direct', action='store_true')
ap.add_argument('--solver', default=os.path.join(HERE, '../../bin/kissat'))
ap.add_argument('--save', default=None)
a = ap.parse_args()
for k in range(a.kmin, a.kmax + 1):
    m = a.m if a.m is not None else k
    t0 = time.time()
    f = direct if a.direct else cegis
    res, prog, outs, it, nw, c = f(a.n, k, a.D, a.model, m, a.iset, a.out, None, a.sb, a.solver,
                                   '%d_%d_%d_%s_%s' % (a.n, k, a.D, a.model, a.out))
    line = 'n=%d k=%d D=%d model=%s R=%d iset=%s out=%s sb=%s: %s (%s it=%d |W|=%d, %.1fs)' % (
        a.n, k, a.D, a.model, a.n + m, a.iset, a.out, a.sb, 'SAT' if res else 'UNSAT',
        'direct' if a.direct else 'cegis', it, nw, time.time() - t0)
    print(line, flush=True)
    if res:
        full = full_program(prog, outs, a.n)
        ok, _ = check(full, a.n)
        ds = {mm: depth(full, LAT[mm])[0] for mm in LAT}
        print('   strict-correct=%s depth U=%d E=%d Z2=%d outs=%s' % (ok, ds['U'], ds['E'], ds['Z2'], outs))
        for st in full:
            if st[0] != 'load':
                print('   ' + ('out %d, %s' % st[1:] if st[0] == 'store' else '%s %s, %s' % st))
        if a.save:
            write_s(a.save, prog, outs, a.n, '# n=%d R=%d iset=%s model=? source=latency/sweep.py k=%d latmodel=%s D=%d strict=%s depthU=%d depthE=%d depthZ2=%d' % (
                a.n, a.n + m, a.iset, k, a.model, a.D, ok, ds['U'], ds['E'], ds['Z2']))
        break
