"""Incremental CEGIS version of regsat.py (same encoding, latency agent).

The program skeleton (opcode/dst/src choice, static depth variables, output choice) is built
once; the semantics of one order type w is added only when w is a counterexample.  UNSAT on
a subset of order types => UNSAT on all (shared/MODEL.md sec. 3, Lemma L1b), so UNSAT is final.

Rules (--rules, each removes only programs that have a no-longer, no-deeper equivalent;
listed in RULES_LATENCY.md for review by theory):
  R0 no mov r,r / cmovcc r,r (always on: no-op)
  R1 scratch first-use order (S_{i+1} is first referenced after S_i; dst before src)
  R2 cmp A,B needs index(A) < index(B)  (cmp B,A = cmp A,B with l<->g, le<->ge swapped in the cmovs
     that read it; forbids cmp r,r)
  R3 no cmp directly after cmp (the first is dead)
  R4 no cmov before the first cmp (relaxed flags = eq: cmovl/g = no-op, cmovle/ge = mov)
usage: python3 regcegis.py n D kmin kmax [--model U|E|Z2] [--m M] [--iset I0|I1] [--out snap|free|fixed]
                           [--rules R1,R2,R3,R4|all|none] [--save f.s]
"""
import sys, os, argparse, time
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from pysat.solvers import Solver
from prog import weak_orders, check, depth, LAT, run
from regsat import full_program, write_s


class Enc:
    def __init__(s, n, k, D, model='U', m=None, iset='I1', out='snap', rules=()):
        s.n, s.k, s.D = n, k, D
        s.m = k if m is None else m
        s.R = n + s.m
        s.regs = ['P%d' % i for i in range(n)] + ['S%d' % i for i in range(s.m)]
        s.vals = list(range(n)) + ['T']
        s.ops = ['mov', 'cmp', 'cmovl', 'cmovg'] + (['cmovle', 'cmovge'] if iset == 'I1' else [])
        s.cmovs = [o for o in s.ops if o.startswith('cmov')]
        s.out = out
        s.nv = 0
        s.solver = Solver(name='cadical195')
        s.nclauses = 0
        movlat = 1 if model == 'U' else 0
        cmplat = 2 if model == 'Z2' else 1
        R, D = s.R, D
        V = s.var
        s.TRUE = V(); s.add([s.TRUE]); F = -s.TRUE
        # static depth: g[t][r][l] l = 1..D+1 (D+1 always false)
        g = [[[F] * (D + 2) for _ in range(R)]]
        fg = [[F] * (D + 2)]
        s.sel = []
        used = [F] * s.m
        prev_cmp = F
        seen_cmp = F
        for t in range(s.k):
            op = {o: V() for o in s.ops}; s.exactly_one(list(op.values()))
            dst = [V() for _ in range(R)]; s.exactly_one(dst)
            src = [V() for _ in range(R)]; s.exactly_one(src)
            s.sel.append((op, dst, src))
            for ri in range(R):
                s.add([-dst[ri], -src[ri], op['cmp']])            # R0
            if 'R2' in rules:
                for a in range(R):
                    for b in range(a + 1):
                        s.add([-op['cmp'], -dst[a], -src[b]])     # need a < b
            if 'R3' in rules:
                s.add([-prev_cmp, -op['cmp']])
            prev_cmp = op['cmp']
            if 'R4' in rules:
                for o in s.cmovs:
                    s.add([-op[o], seen_cmp])
                ns = V(); s.add([-seen_cmp, ns]); s.add([-op['cmp'], ns]); s.add([seen_cmp, op['cmp'], -ns])
                seen_cmp = ns
            if 'R1' in rules:
                n_ = n
                for i in range(s.m - 1):
                    s.add([-dst[n_ + i + 1], used[i]])
                    s.add([-src[n_ + i + 1], used[i], dst[n_ + i]])
                nu = [V() for _ in range(s.m)]
                for i in range(s.m):
                    s.add([-used[i], nu[i]]); s.add([-dst[n_ + i], nu[i]]); s.add([-src[n_ + i], nu[i]])
                    s.add([used[i], dst[n_ + i], src[n_ + i], -nu[i]])
                used = nu
            wr = -op['cmp']
            SD = [None] + [V() for _ in range(D + 1)]
            DD = [None] + [V() for _ in range(D + 1)]
            for ri in range(R):
                for l in range(1, D + 2):
                    s.add([-src[ri], -g[t][ri][l], SD[l]])
                    s.add([-dst[ri], -g[t][ri][l], DD[l]])
            NEW = [None] + [V() for _ in range(D)] + [F, F, F]
            for l in range(1, D + 2):
                s.add([-op['mov'], -SD[l], NEW[min(l + movlat, D + 1)]])
            if movlat:
                s.add([-op['mov'], NEW[1]])
            for o in s.cmovs:
                s.add([-op[o], NEW[1]])
                for l in range(1, D + 1):
                    s.add([-op[o], -SD[l], NEW[l + 1]])
                    s.add([-op[o], -DD[l], NEW[l + 1]])
                    s.add([-op[o], -fg[t][l], NEW[l + 1]])
            nfg = [F] + [V() for _ in range(D)] + [F]
            for l in range(1, min(cmplat, D + 1) + 1):
                s.add([-op['cmp'], nfg[l]])
            for l in range(1, D + 1):
                for X in (SD, DD):
                    s.add([-op['cmp'], -X[l], nfg[min(l + cmplat, D + 1)]])
                s.add([op['cmp'], -fg[t][l], nfg[l]])
            fg.append(nfg)
            ng = []
            for ri in range(R):
                row = [F] + [V() for _ in range(D)] + [F]
                for l in range(1, D + 1):
                    s.add([-dst[ri], -wr, -NEW[l], row[l]])
                    s.add([dst[ri], -g[t][ri][l], row[l]])
                    s.add([wr, -g[t][ri][l], row[l]])
                ng.append(row)
            g.append(ng)
        s.g = g
        # outputs
        if out == 'snap':
            s.o = [[[V() for _ in range(R)] for _ in range(s.k + 1)] for j in range(n)]
            for j in range(n):
                s.exactly_one([x for row in s.o[j] for x in row])
            s.ocand = lambda j: [(t, ri, s.o[j][t][ri]) for t in range(s.k + 1) for ri in range(R)]
        else:
            if out == 'fixed':
                s.o = [[s.TRUE if ri == j else F for ri in range(R)] for j in range(n)]
            else:
                s.o = [[V() for _ in range(R)] for j in range(n)]
                for j in range(n):
                    s.exactly_one(s.o[j])
                for ri in range(R):
                    s.at_most_one([s.o[j][ri] for j in range(n)])
            s.ocand = lambda j: [(s.k, ri, s.o[j][ri]) for ri in range(R)]

    def var(s):
        s.nv += 1; return s.nv

    def add(s, c):
        s.solver.add_clause(c); s.nclauses += 1

    def at_most_one(s, xs):
        xs = list(xs)
        if len(xs) <= 6:
            for i in range(len(xs)):
                for j in range(i + 1, len(xs)):
                    s.add([-xs[i], -xs[j]])
            return
        prev = None
        for i, x in enumerate(xs):
            if i < len(xs) - 1:
                r = s.var(); s.add([-x, r])
                if prev:
                    s.add([-prev, r]); s.add([-prev, -x])
                prev = r
            else:
                s.add([-prev, -x])

    def exactly_one(s, xs):
        s.add(list(xs)); s.at_most_one(xs)

    def add_ot(s, w):
        n, R, V, F = s.n, s.R, s.var, -s.TRUE
        rank = lambda c: n + 1 if c == 'T' else w[c]
        cond = {'cmovl': lambda lt, gt: lt, 'cmovg': lambda lt, gt: gt,
                'cmovle': lambda lt, gt: -gt, 'cmovge': lambda lt, gt: -lt}
        val = [[{x: (s.TRUE if ((x == ri) if ri < n else (x == 'T')) else F) for x in s.vals} for ri in range(R)]]
        lt, gt = F, F
        for t, (op, dst, src) in enumerate(s.sel):
            SV = {x: V() for x in s.vals}; DV = {x: V() for x in s.vals}
            for ri in range(R):
                for x in s.vals:
                    s.add([-src[ri], -val[t][ri][x], SV[x]])
                    s.add([-dst[ri], -val[t][ri][x], DV[x]])
            s.at_most_one(list(SV.values())); s.at_most_one(list(DV.values()))
            nlt, ngt = V(), V()
            for x in s.vals:
                for y in s.vals:
                    a, b = rank(x), rank(y)
                    s.add([-op['cmp'], -DV[x], -SV[y], nlt if a < b else -nlt])
                    s.add([-op['cmp'], -DV[x], -SV[y], ngt if a > b else -ngt])
            s.add([op['cmp'], -lt, nlt]); s.add([op['cmp'], lt, -nlt])
            s.add([op['cmp'], -gt, ngt]); s.add([op['cmp'], gt, -ngt])
            NV = {x: V() for x in s.vals}
            for x in s.vals:
                s.add([-op['mov'], -SV[x], NV[x]])
                for o in s.cmovs:
                    cnd = cond[o](lt, gt)
                    s.add([-op[o], -cnd, -SV[x], NV[x]])
                    s.add([-op[o], cnd, -DV[x], NV[x]])
            nval = []
            for ri in range(R):
                row = {x: V() for x in s.vals}
                s.exactly_one(list(row.values()))
                for x in s.vals:
                    s.add([-dst[ri], op['cmp'], -NV[x], row[x]])
                    s.add([dst[ri], -val[t][ri][x], row[x]])
                    s.add([-op['cmp'], -val[t][ri][x], row[x]])
                nval.append(row)
            val.append(nval)
            lt, gt = nlt, ngt
        for j in range(n):
            tgt = sorted(w)[j]
            for (t, ri, ov) in s.ocand(j):
                for x in s.vals:
                    if x == 'T' or w[x] != tgt:
                        s.add([-ov, -val[t][ri][x]])

    def decode(s, model):
        M = set(x for x in model if x > 0)
        prog = []
        for op, dst, src in s.sel:
            oo = [x for x in s.ops if op[x] in M][0]
            d = s.regs[[i for i, v in enumerate(dst) if v in M][0]]
            sr = s.regs[[i for i, v in enumerate(src) if v in M][0]]
            prog.append((oo, d, sr))
        outs = []
        for j in range(s.n):
            t, ri, _ = [c for c in s.ocand(j) if c[2] == s.TRUE or c[2] in M][0]
            outs.append((t, s.regs[ri]) if s.out == 'snap' else s.regs[ri])
        return prog, outs


def relaxed_ok(prog, outs, n, w):
    full = full_program(prog, outs, n)
    regs = {r for p in full for r in (p[1], p[2]) if isinstance(r, str)}
    o = run(full, list(w), {r: 10 ** 9 for r in regs}, (False, False))
    return [o[j] for j in range(n)] == sorted(w)


def cegis(n, k, D, model, m, iset, out, rules, log=None):
    e = Enc(n, k, D, model, m, iset, out, rules)
    allW = weak_orders(n)
    Wsub = [w for w in allW if len(set(w)) == n][:1]
    for w in Wsub:
        e.add_ot(w)
    while True:
        if not e.solver.solve():
            return False, None, None, Wsub, e
        prog, outs = e.decode(e.solver.get_model())
        bad = [w for w in allW if not relaxed_ok(prog, outs, n, w)]
        if not bad:
            return True, prog, outs, Wsub, e
        w = bad[0]
        Wsub.append(w); e.add_ot(w)
        if log:
            log('  cex %d: %s' % (len(Wsub), w))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('n', type=int); ap.add_argument('D', type=int); ap.add_argument('kmin', type=int); ap.add_argument('kmax', type=int)
    ap.add_argument('--model', default='U'); ap.add_argument('--m', type=int, default=None)
    ap.add_argument('--iset', default='I1'); ap.add_argument('--out', default='snap')
    ap.add_argument('--rules', default='all'); ap.add_argument('--save', default=None)
    a = ap.parse_args()
    rules = {'all': ('R1', 'R2', 'R3', 'R4'), 'none': ()}.get(a.rules, tuple(a.rules.split(',')))
    for k in range(a.kmin, a.kmax + 1):
        m = a.m if a.m is not None else k
        t0 = time.time()
        res, prog, outs, Wsub, e = cegis(a.n, k, a.D, a.model, m, a.iset, a.out, rules)
        print('n=%d k=%d D=%d model=%s R=%d iset=%s out=%s rules=%s: %s (|W|=%d, %.1fs)' % (
            a.n, k, a.D, a.model, a.n + m, a.iset, a.out, ','.join(rules) or 'none',
            'SAT' if res else 'UNSAT', len(Wsub), time.time() - t0), flush=True)
        if res:
            full = full_program(prog, outs, a.n)
            ok, _ = check(full, a.n)
            ds = {mm: depth(full, LAT[mm])[0] for mm in LAT}
            print('   strict-correct=%s depth U=%d E=%d Z2=%d' % (ok, ds['U'], ds['E'], ds['Z2']))
            for st in full:
                if st[0] != 'load':
                    print('   ' + ('out %d, %s' % st[1:] if st[0] == 'store' else '%s %s, %s' % st))
            if a.save:
                write_s(a.save, prog, outs, a.n, '# n=%d R=%d iset=%s model=? source=latency/regcegis.py k=%d latmodel=%s D=%d rules=%s strict=%s depthU=%d depthE=%d depthZ2=%d' % (
                    a.n, a.n + m, a.iset, k, a.model, a.D, ','.join(rules), ok, ds['U'], ds['E'], ds['Z2']))
            break


if __name__ == '__main__':
    main()
