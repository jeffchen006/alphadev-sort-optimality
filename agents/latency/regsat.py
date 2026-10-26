"""Register-machine SAT with static critical-path depth (latency agent, own encoding).

Question Q(n, k, D, model, R, iset, outmode): is there a program of exactly k instructions
over R = n + m registers (P0..P{n-1} hold the inputs, S0..S{m-1} start as T), that sorts
every weak order type of n inputs (lower-bound relaxation of shared/MODEL.md sec. 2: T is
larger than every input, initial flags = eq), and whose critical path is <= D in latency
model U (all ops 1) or E (mov 0, cmp 1, cmov 1)?
  outmode 'fixed': output j in Pj (shared/MODEL.md)
  outmode 'free' : output j in any register, distinct registers (AlphaDev memory form:
                   the stores pick the register; loads/stores not counted).
Depth = longest RAW chain over registers and flags (WAR/WAW ignored: renaming).
Depth variables are unary over-approximations: g[t][r][l] => "depth of r before step t
may be >= l"; every instruction must produce depth <= D (an instruction of depth > D can
never feed an output; deleting all of them keeps the outputs, so min length is unchanged).

Padding: exactly k steps; a no-op is not allowed (mov r,r and cmovcc r,r forbidden), so
"UNSAT at k" alone does not imply UNSAT at k-1; we sweep all k' <= k.

usage: python3 regsat.py n k D [--model U|E] [--m M] [--iset I0|I1] [--out free|fixed]
                         [--cnf f] [--proof f] [--solver s] [--save prog.s]
"""
import sys, os, argparse, subprocess, itertools
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from prog import weak_orders, check, depth as pdepth, LAT, counts
from relax import CNF

HERE = os.path.dirname(os.path.abspath(__file__))


def build(n, k, D, model='U', m=None, iset='I0', out='free', perout=None, W=None, sb=False):
    if m is None:
        m = k
    R = n + m
    regs = ['P%d' % i for i in range(n)] + ['S%d' % i for i in range(m)]
    if W is None:
        W = weak_orders(n)
    vals = list(range(n)) + ['T']
    rank = lambda w, c: n + 1 if c == 'T' else w[c]
    ops = ['mov', 'cmp', 'cmovl', 'cmovg'] + (['cmovle', 'cmovge'] if iset == 'I1' else [])
    cmovs = [o for o in ops if o.startswith('cmov')]
    cond = {'cmovl': lambda lt, gt: lt, 'cmovg': lambda lt, gt: gt,
            'cmovle': lambda lt, gt: -gt, 'cmovge': lambda lt, gt: -lt}
    movlat = 1 if model == 'U' else 0
    cmplat = 2 if model == 'Z2' else 1
    c = CNF()
    V = c.var
    # state
    val = [[[{x: None for x in vals} for _ in W] for _ in regs] for _ in range(k + 1)]
    LT = [[None] * len(W) for _ in range(k + 1)]
    GT = [[None] * len(W) for _ in range(k + 1)]
    g = [[[None] * (D + 2) for _ in regs] for _ in range(k + 1)]   # g[t][r][l], l=1..D
    fg = [[None] * (D + 2) for _ in range(k + 1)]
    TRUE = V(); c.add([TRUE])
    FALSE = -TRUE
    for ri, r in enumerate(regs):
        for wi, w in enumerate(W):
            for x in vals:
                init = (x == ri) if ri < n else (x == 'T')
                val[0][ri][wi][x] = TRUE if init else FALSE
        for l in range(1, D + 2):
            g[0][ri][l] = FALSE
    for wi in range(len(W)):
        LT[0][wi] = FALSE; GT[0][wi] = FALSE
    for l in range(1, D + 2):
        fg[0][l] = FALSE
    sel = []
    for t in range(k):
        op = {o: V() for o in ops}; c.exactly_one(op.values())
        dst = [V() for _ in regs]; c.exactly_one(dst)
        src = [V() for _ in regs]; c.exactly_one(src)
        sel.append((op, dst, src))
        if sb:  # scratch symmetry: S_{i+1} first referenced after S_i (dst before src)
            if t == 0:
                used = [FALSE] * m
            for i in range(m - 1):
                c.add([-dst[n + i + 1], used[i]])
                c.add([-src[n + i + 1], used[i], dst[n + i]])
            nused = [V() for _ in range(m)]
            for i in range(m):
                c.add([-used[i], nused[i]]); c.add([-dst[n + i], nused[i]]); c.add([-src[n + i], nused[i]])
                c.add([used[i], dst[n + i], src[n + i], -nused[i]])
            used = nused
        for ri in range(R):  # no-ops: mov r,r / cmov r,r
            c.add([-dst[ri], -src[ri], op['cmp']])
        wr = V()  # writes a register
        c.add([-op['cmp'], -wr]); c.add([op['cmp'], wr])
        # next-state vars
        for ri in range(R):
            for wi in range(len(W)):
                row = val[t + 1][ri][wi]
                for x in vals:
                    row[x] = V()
                c.exactly_one(row.values())
            for l in range(1, D + 1):
                g[t + 1][ri][l] = V()
            g[t + 1][ri][D + 1] = FALSE
        for l in range(1, D + 1):
            fg[t + 1][l] = V()
        fg[t + 1][D + 1] = FALSE
        # operand depths SD, DD (over-approx)
        SD = [None] + [V() for _ in range(D + 1)]
        DD = [None] + [V() for _ in range(D + 1)]
        for ri in range(R):
            for l in range(1, D + 2):
                c.add([-src[ri], -g[t][ri][l], SD[l]])
                c.add([-dst[ri], -g[t][ri][l], DD[l]])
        NEW = [None] + [V() for _ in range(D + 1)] + [FALSE]   # depth of written value, index up to D+2
        NEW[D + 1] = FALSE
        # mov
        for l in range(1, D + 2):
            if l + movlat <= D + 1:
                c.add([-op['mov'], -SD[l], NEW[l + movlat]] if l + movlat <= D + 1 else [-op['mov'], -SD[l]])
            else:
                c.add([-op['mov'], -SD[l]])
        if movlat:
            c.add([-op['mov'], NEW[1]])
        for o in cmovs:
            c.add([-op[o], NEW[1]])
            for l in range(1, D + 1):
                for X in (SD, DD):
                    c.add([-op[o], -X[l], NEW[l + 1]])
                c.add([-op[o], -fg[t][l], NEW[l + 1]])
        # cmp: flags depth
        for l in range(1, min(cmplat, D + 1) + 1):
            c.add([-op['cmp'], fg[t + 1][l]])
        for l in range(1, D + 1):
            for X in (SD, DD):
                c.add([-op['cmp'], -X[l], fg[t + 1][l + cmplat]] if l + cmplat <= D + 1 else [-op['cmp'], -X[l]])
        for l in range(1, D + 1):
            c.add([op['cmp'], -fg[t][l], fg[t + 1][l]])
        # register depths
        for ri in range(R):
            for l in range(1, D + 1):
                c.add([-dst[ri], -wr, -NEW[l], g[t + 1][ri][l]])
                c.add([dst[ri], -g[t][ri][l], g[t + 1][ri][l]])
                c.add([wr, -g[t][ri][l], g[t + 1][ri][l]])
        # semantics per order type
        for wi, w in enumerate(W):
            SV = {x: V() for x in vals}; DV = {x: V() for x in vals}
            for ri in range(R):
                for x in vals:
                    c.add([-src[ri], -val[t][ri][wi][x], SV[x]])
                    c.add([-dst[ri], -val[t][ri][wi][x], DV[x]])
            c.at_most_one(SV.values()); c.at_most_one(DV.values())
            lt, gt = LT[t][wi], GT[t][wi]
            nlt, ngt = V(), V()
            LT[t + 1][wi] = nlt; GT[t + 1][wi] = ngt
            for x in vals:
                for y in vals:
                    a, b = rank(w, x), rank(w, y)
                    c.add([-op['cmp'], -DV[x], -SV[y], nlt if a < b else -nlt])
                    c.add([-op['cmp'], -DV[x], -SV[y], ngt if a > b else -ngt])
            c.add([op['cmp'], -lt, nlt]); c.add([op['cmp'], lt, -nlt])
            c.add([op['cmp'], -gt, ngt]); c.add([op['cmp'], gt, -ngt])
            NV = {x: V() for x in vals}   # written value
            for x in vals:
                c.add([-op['mov'], -SV[x], NV[x]])
                for o in cmovs:
                    cnd = cond[o](lt, gt)   # literal: condition holds
                    c.add([-op[o], -cnd, -SV[x], NV[x]])
                    c.add([-op[o], cnd, -DV[x], NV[x]])
            for ri in range(R):
                for x in vals:
                    c.add([-dst[ri], -wr, -NV[x], val[t + 1][ri][wi][x]])
                    c.add([dst[ri], -val[t][ri][wi][x], val[t + 1][ri][wi][x]])
                    c.add([wr, -val[t][ri][wi][x], val[t + 1][ri][wi][x]])
    # outputs
    if out == 'snap':
        # output j = value of register r after step t (any t, r): M_out of shared/MODEL.md 4.3
        o = [[[V() for _ in range(R)] for _ in range(k + 1)] for j in range(n)]
        for j in range(n):
            c.exactly_one([x for row in o[j] for x in row])
            for t in range(k + 1):
                for ri in range(R):
                    for wi, w in enumerate(W):
                        tgt = sorted(w)[j]
                        for x in vals:
                            if x == 'T' or w[x] != tgt:
                                c.add([-o[j][t][ri], -val[t][ri][wi][x]])
                    if perout:
                        c.add([-o[j][t][ri], -g[t][ri][perout[j] + 1]])
        return c, sel, o, regs, ops
    if out == 'fixed':
        o = [[TRUE if ri == j else FALSE for ri in range(R)] for j in range(n)]
    else:
        o = [[V() for _ in range(R)] for j in range(n)]
        for j in range(n):
            c.exactly_one(o[j])
        for ri in range(R):
            c.at_most_one([o[j][ri] for j in range(n)])
    for j in range(n):
        for ri in range(R):
            for wi, w in enumerate(W):
                tgt = sorted(w)[j]
                for x in vals:
                    if x == 'T' or w[x] != tgt:
                        c.add([-o[j][ri], -val[k][ri][wi][x]])
            if perout:
                c.add([-o[j][ri], -g[k][ri][perout[j] + 1]])
    return c, sel, o, regs, ops


def solve(c, solver, path, proof=None, timeout=None):
    c.dimacs(path)
    cmd = [solver, '-q', path] + ([proof] if proof else [])
    if proof and 'kissat' in solver:
        cmd.insert(1, '--no-binary')
    try:
        r = subprocess.run(cmd, capture_output=True, text=True, timeout=timeout)
    except subprocess.TimeoutExpired:
        return None, None
    if 's SATISFIABLE' in r.stdout:
        model = set()
        for line in r.stdout.splitlines():
            if line.startswith('v '):
                model.update(int(x) for x in line[2:].split() if int(x) > 0)
        return True, model
    if 's UNSATISFIABLE' in r.stdout:
        return False, None
    raise RuntimeError(r.stdout + r.stderr)


def decode(model, sel, o, regs, ops, n):
    prog = []
    for op, dst, src in sel:
        oo = [x for x in ops if op[x] in model][0]
        d = regs[[i for i, v in enumerate(dst) if v in model][0]]
        s = regs[[i for i, v in enumerate(src) if v in model][0]]
        prog.append((oo, d, s))
    outs = []
    for j in range(n):
        if isinstance(o[j][0], list):   # snap: (t, reg)
            t, ri = [(t, ri) for t in range(len(o[j])) for ri in range(len(o[j][t])) if o[j][t][ri] in model][0]
            outs.append((t, regs[ri]))
        else:
            outs.append(regs[[i for i, v in enumerate(o[j]) if v is True or (isinstance(v, int) and v > 0 and v in model)][0]])
    return prog, outs


def full_program(prog, outs, n):
    """internal form with loads and stores (snap outputs placed after step t)"""
    full = [('load', 'P%d' % i, i) for i in range(n)]
    snaps = {}
    for j, o in enumerate(outs):
        if isinstance(o, tuple):
            snaps.setdefault(o[0], []).append(('store', j, o[1]))
    for t, p in enumerate(prog):
        full += snaps.get(t, [])
        full.append(p)
    full += snaps.get(len(prog), [])
    full += [('store', j, o) for j, o in enumerate(outs) if not isinstance(o, tuple)]
    return full


def write_s(path, prog, outs, n, header):
    with open(path, 'w') as f:
        snap = isinstance(outs[0], tuple)
        f.write(header.replace('model=?', 'model=out') + '\n')
        for st in full_program(prog, outs, n):
            if st[0] == 'load':
                continue
            if st[0] == 'store':
                f.write('out %d, %s\n' % (st[1], st[2]))
            else:
                f.write('%s %s, %s\n' % st)


def relaxed_ok(prog, outs, n, w):
    """run on order type w in the relaxed model (scratch = T, flags = eq)"""
    from prog import run
    full = [('load', 'P%d' % i, i) for i in range(n)] + prog
    regs = {r for p in prog for r in (p[1], p[2])}
    g = {r: 10 ** 9 for r in regs}
    regsv = dict(g)
    lt = gt = False
    for i in range(n):
        regsv['P%d' % i] = w[i]
    for op, d, s_ in prog:
        if op == 'mov': regsv[d] = regsv[s_]
        elif op == 'cmp': lt, gt = regsv[d] < regsv[s_], regsv[d] > regsv[s_]
        else:
            from prog import CC
            if CC[op](lt, gt): regsv[d] = regsv[s_]
    return [regsv[outs[j]] for j in range(n)] == sorted(w)


def relaxed_ok_full(prog, outs, n, w):
    """relaxed run (scratch = T = 10**9, flags = eq) of the full program incl. snapshot stores"""
    from prog import run
    full = full_program(prog, outs, n)
    regs = {r for p in full for r in (p[1], p[2]) if isinstance(r, str)}
    o = run(full, list(w), {r: 10 ** 9 for r in regs}, (False, False))
    return [o[j] for j in range(n)] == sorted(w)


def cegis(n, k, D, model, m, iset, out, perout, sb, solver, tag, log=lambda x: print(x, flush=True)):
    allW = weak_orders(n)
    # seed: all permutations with distinct values? start small: identity-free few
    Wsub = [w for w in allW if len(set(w)) == n][:2]
    it = 0
    while True:
        it += 1
        c, sel, o, regs, ops = build(n, k, D, model, m, iset, out, perout, Wsub, sb)
        path = os.path.join(HERE, 'cnf', 'cg_%s_%d.cnf' % (tag, os.getpid()))
        res, model_ = solve(c, solver, path)
        os.remove(path)
        if not res:
            return False, None, None, it, len(Wsub), c
        prog, outs = decode(model_, sel, o, regs, ops, n)
        bad = [w for w in allW if not relaxed_ok_full(prog, outs, n, w)]
        if not bad:
            return True, prog, outs, it, len(Wsub), c
        Wsub.append(bad[len(bad) // 2])
        log('   cegis it=%d |W|=%d' % (it, len(Wsub)))


def direct(n, k, D, model, m, iset, out, perout, sb, solver, tag):
    c, sel, o, regs, ops = build(n, k, D, model, m, iset, out, perout, None, sb)
    path = os.path.join(HERE, 'cnf', 'dr_%s_%d.cnf' % (tag, os.getpid()))
    res, model_ = solve(c, solver, path)
    os.remove(path)
    if not res:
        return False, None, None, 1, len(weak_orders(n)), c
    prog, outs = decode(model_, sel, o, regs, ops, n)
    return True, prog, outs, 1, len(weak_orders(n)), c


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('n', type=int); ap.add_argument('k', type=int); ap.add_argument('D', type=int)
    ap.add_argument('--model', default='U'); ap.add_argument('--m', type=int, default=None)
    ap.add_argument('--iset', default='I0'); ap.add_argument('--out', default='free')
    ap.add_argument('--perout', default=None, help='per-output depth limits, comma list')
    ap.add_argument('--cnf', default=None); ap.add_argument('--proof', default=None)
    ap.add_argument('--solver', default=os.path.join(HERE, '../../bin/kissat'))
    ap.add_argument('--save', default=None)
    ap.add_argument('--fix', default=None, help='fix the program to this .s file (encoding test)')
    a = ap.parse_args()
    perout = [int(x) for x in a.perout.split(',')] if a.perout else None
    c, sel, o, regs, ops = build(a.n, a.k, a.D, a.model, a.m, a.iset, a.out, perout)
    if a.fix:
        lines = [l.split('#')[0].strip() for l in open(a.fix)]
        lines = [l for l in lines if l]
        for (op, dst, src), l in zip(sel, lines):
            oo, args = l.split(None, 1); d, s_ = [x.strip() for x in args.split(',')]
            c.add([op[oo]]); c.add([dst[regs.index(d)]]); c.add([src[regs.index(s_)]])
    path = a.cnf or os.path.join(HERE, 'cnf', 'reg_%d_%d_%d_%s_%d.cnf' % (a.n, a.k, a.D, a.model, os.getpid()))
    res, model = solve(c, a.solver, path, a.proof)
    m = a.m if a.m is not None else a.k
    head = 'n=%d k=%d D=%d model=%s R=%d iset=%s out=%s vars=%d clauses=%d' % (
        a.n, a.k, a.D, a.model, a.n + m, a.iset, a.out, c.nv, len(c.cl))
    if not res:
        print(head, '-> UNSAT')
    else:
        prog, outs = decode(model, sel, o, regs, ops, a.n)
        full = full_program(prog, outs, a.n)
        ok, cex = check(full, a.n)
        dU, dE = pdepth(full, LAT['U'])[0], pdepth(full, LAT['E'])[0]
        print(head, '-> SAT strict-correct=%s depthU=%d depthE=%d outs=%s' % (ok, dU, dE, outs))
        for p in prog:
            print('   %s %s, %s' % p)
        if a.save:
            write_s(a.save, prog, outs, a.n, '# n=%d R=%d iset=%s model=? source=latency/regsat.py k=%d latmodel=%s D=%d out=%s strict=%s depthU=%d depthE=%d' % (
                a.n, a.n + m, a.iset, a.k, a.model, a.D, a.out, ok, dU, dE))
    if not a.cnf:
        os.remove(path)


if __name__ == '__main__':
    main()
