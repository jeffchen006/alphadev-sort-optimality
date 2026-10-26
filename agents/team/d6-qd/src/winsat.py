#!/usr/bin/env python3
"""d6-qd: exact window test for sort5 in M_out (I1), strict 3-valued semantics (same as upper sim.h).
Given a correct program P (length K) and a window [i, i+w), decide by SAT (CEGIS over weak-order tests) whether
some sequence of <= w-1 instructions (registers: those used in P + `fresh` new ones) can replace the window so
that the program sorts all 541 weak orders (outputs: any register at any write step, 'out' free).
UNSAT on a test subset => UNSAT on all tests (exact negative). SAT => candidate checked on all tests.
Usage: winsat.py prog.s -w W [-i a:b] [-fresh F]   (prog file: one program, 'out' lines ignored)
"""
import sys, itertools, random, time
import numpy as np
from pysat.solvers import Cadical195

N = 5
SYM = True
NINIT = 24
U = 5                      # garbage value
F_LT, F_EQ, F_GT, F_U = 0, 1, 2, 3
OPS = ['nop', 'mov', 'cmp', 'cmovl', 'cmovg', 'cmovle', 'cmovge']
CMOVS = ['cmovl', 'cmovg', 'cmovle', 'cmovge']
COND = {'cmovl': (F_LT,), 'cmovg': (F_GT,), 'cmovle': (F_LT, F_EQ), 'cmovge': (F_GT, F_EQ)}


def weak_orders(n=N):
    out = []
    for v in itertools.product(range(n), repeat=n):
        s = set(v)
        if s == set(range(len(s))):
            out.append(v)
    return out


TESTS = weak_orders()
NT = len(TESTS)
EXP = np.array([sorted(t) for t in TESTS], dtype=np.uint8).T   # EXP[j][k]


def parse_regs(prog_lines):
    regs = {}
    for i in range(N):
        regs['P%d' % i] = i
    prog = []
    for op, d, s in prog_lines:
        for r in (d, s):
            if r not in regs:
                regs[r] = len(regs)
        prog.append((op, regs[d], regs[s]))
    names = {v: k for k, v in regs.items()}
    return prog, names


def read_prog(fn):
    lines = []
    for line in open(fn):
        line = line.split('#')[0].strip()
        if not line:
            continue
        op, rest = line.split(None, 1)
        if op == 'out':
            continue
        d, s = [x.strip() for x in rest.split(',')]
        lines.append((op, d, s))
    return lines


# ---------------- numpy strict simulator ----------------
def sim_states(prog, R, tests=None):
    """yield (step index, regs array, flags) BEFORE each step and after last. regs: R x T"""
    T = np.array(TESTS if tests is None else tests, dtype=np.uint8).T
    nt = T.shape[1]
    regs = np.full((R, nt), U, dtype=np.uint8)
    regs[:N] = T
    fl = np.full(nt, F_U, dtype=np.uint8)
    states = [(regs.copy(), fl.copy())]
    for op, d, s in prog:
        a, b = regs[d], regs[s]
        if op == 'mov':
            regs[d] = b
        elif op == 'cmp':
            unk = (a == U) | (b == U)
            fl = np.where(unk, F_U, np.where(a < b, F_LT, np.where(a > b, F_GT, F_EQ))).astype(np.uint8)
        elif op in COND:
            mv = np.isin(fl, COND[op])
            un = (fl == F_U) & (a != b)
            regs[d] = np.where(mv, b, np.where(un, U, a))
        elif op == 'nop':
            pass
        else:
            raise ValueError(op)
        states.append((regs.copy(), fl.copy()))
    return states


def out_errors(prog, R):
    """per output j: min over write steps of #tests wrong; returns (errs, steps, failing-test-sets)"""
    states = sim_states(prog, R)
    best = [NT + 1] * N
    pos = [None] * N
    for t, (op, d, s) in enumerate(prog):
        if op not in ('mov',) and op not in COND:
            continue
        v = states[t + 1][0][d]
        for j in range(N):
            c = int((v != EXP[j]).sum())
            if c < best[j]:
                best[j] = c
                pos[j] = (t, d)
    return best, pos, states


# ---------------- CNF gate library with constant folding ----------------
class CNF:
    def __init__(self, solver):
        self.S = solver
        self.nv = 0
        self.ncl = 0
        self.cache = {}

    def new(self):
        self.nv += 1
        return self.nv

    def cl(self, *lits):
        out = []
        for l in lits:
            if l is True:
                return
            if l is False:
                continue
            out.append(l)
        if not out:
            raise RuntimeError('empty clause')
        self.S.add_clause(out)
        self.ncl += 1

    @staticmethod
    def neg(a):
        if a is True:
            return False
        if a is False:
            return True
        return -a

    def AND(self, *xs):
        ys = []
        for x in xs:
            if x is False:
                return False
            if x is True:
                continue
            ys.append(x)
        ys = sorted(set(ys))
        if not ys:
            return True
        if len(ys) == 1:
            return ys[0]
        for y in ys:
            if -y in ys:
                return False
        key = ('and',) + tuple(ys)
        if key in self.cache:
            return self.cache[key]
        z = self.new()
        for y in ys:
            self.S.add_clause([-z, y])
        self.S.add_clause([z] + [-y for y in ys])
        self.ncl += len(ys) + 1
        self.cache[key] = z
        return z

    def OR(self, *xs):
        return self.neg(self.AND(*[self.neg(x) for x in xs]))

    def MUX(self, s, a, b):   # s ? a : b
        if s is True:
            return a
        if s is False:
            return b
        if a == b:
            return a
        if a is True and b is False:
            return s
        if a is False and b is True:
            return -s
        key = ('mux', s, a, b)
        if key in self.cache:
            return self.cache[key]
        z = self.new()
        self.cl(-s, self.neg(a), z)
        self.cl(-s, a, -z)
        self.cl(s, self.neg(b), z)
        self.cl(s, b, -z)
        self.cache[key] = z
        return z


def const_vec(v, D):
    return tuple(i == v for i in range(D))


class WinEnc:
    def __init__(self, prog, R, regs, i, w, slots, fresh_regs=()):
        self.prog, self.R, self.i, self.w = prog, R, i, w
        self.regs = list(regs) + list(fresh_regs)
        self.Rtot = max(self.regs) + 1 if self.regs else R
        self.Rtot = max(self.Rtot, R)
        self.m = slots
        self.solver = Cadical195()
        self.C = C = CNF(self.solver)
        self.pre = prog[:i]
        self.suf = prog[i + w:]
        # choice vars
        self.op = [{o: C.new() for o in OPS} for _ in range(self.m)]
        self.d = [{r: C.new() for r in self.regs} for _ in range(self.m)]
        self.s = [{r: C.new() for r in self.regs} for _ in range(self.m)]
        for t in range(self.m):
            for grp in (self.op[t], self.d[t], self.s[t]):
                lits = list(grp.values())
                C.cl(*lits)
                for a, b in itertools.combinations(lits, 2):
                    C.cl(-a, -b)
            for r in self.regs:
                C.cl(-self.d[t][r], -self.s[t][r], self.op[t]["cmp"])   # d == s only for cmp r,r (judge b)
            # nop: canonical operands; nops only at the end
            C.cl(-self.op[t]['nop'], self.d[t][self.regs[0]])
            C.cl(-self.op[t]['nop'], self.s[t][self.regs[1]])
            if t + 1 < self.m:
                C.cl(-self.op[t]['nop'], self.op[t + 1]['nop'])
        # prefix: full states for all tests
        Rs = self.Rtot
        self.states = sim_states(self.pre, Rs)
        self.pre_regs, self.pre_fl = self.states[-1]
        # which outputs are already satisfied in the prefix
        self.pre_ok = [False] * N
        for t, (op, d, s) in enumerate(self.pre):
            if op == 'mov' or op in COND:
                v = self.states[t + 1][0][d]
                for j in range(N):
                    if (v == EXP[j]).all():
                        self.pre_ok[j] = True
        # output selectors: ('w', t) window slot t; ('s', t) suffix step t
        self.sel = {}
        for j in range(N):
            if self.pre_ok[j]:
                continue
            opts = []
            for t in range(self.m):
                v = C.new()
                self.sel[(j, 'w', t)] = v
                C.cl(-v, -self.op[t]['nop'])
                C.cl(-v, -self.op[t]['cmp'])
                opts.append(v)
            for t, (op, d, s) in enumerate(self.suf):
                if op == 'mov' or op in COND:
                    v = C.new()
                    self.sel[(j, 's', t)] = v
                    opts.append(v)
            C.cl(*opts)
        self.tests = []
        if SYM:
            self.symbreak()
            self.liveness()

    def symbreak(self):
        # sound normal form for the window (any window can be rewritten into it with the same effect)
        C, op, d, s = self.C, self.op, self.d, self.s
        writes = lambda t: [op[t][o] for o in ['mov'] + CMOVS]
        for t in range(self.m - 1):
            u = t + 1
            C.cl(-op[t]['cmp'], -op[u]['cmp'])                     # first cmp dead
            for r in self.regs:
                C.cl(-op[t]['mov'], -op[u]['mov'], -d[t][r], -d[u][r])   # first mov dead
                # cmp ; mov r,x (r not read by cmp) -> swap to mov ; cmp
                C.cl(-op[t]['cmp'], -op[u]['mov'], -d[u][r], d[t][r], s[t][r])
            # two independent writes: d[t] < d[u]
            for i1, r1 in enumerate(self.regs):
                for r2 in self.regs[:i1]:
                    C.cl(-d[t][r1], -d[u][r2], s[u][r1], s[t][r2], op[t]['cmp'], op[u]['cmp'], op[t]['nop'], op[u]['nop'])

    def liveness(self):
        # every window write is read later in the window, or live after the window, or an output snapshot;
        # every window cmp is followed by a cmov in the window, or flags are read by the suffix before a cmp
        C, op, d, s = self.C, self.op, self.d, self.s
        live = set()
        for r in self.regs:
            for o, dd, ss in self.suf:
                if ss == r or (o != 'mov' and dd == r):
                    live.add(r); break
                if o == 'mov' and dd == r:
                    break
        flive = False
        for o, dd, ss in self.suf:
            if o in COND:
                flive = True; break
            if o == 'cmp':
                break
        for t in range(self.m):
            outs = [v for (j, kind, tt), v in self.sel.items() if kind == 'w' and tt == t]
            for r in self.regs:
                if r in live:
                    continue
                readers = []
                for u in range(t + 1, self.m):
                    readers.append(s[u][r])
                    readers.append(C.AND(d[u][r], C.OR(op[u]['cmp'], *[op[u][c] for c in CMOVS])))
                C.cl(op[t]['nop'], op[t]['cmp'], -d[t][r], *readers, *outs)
            if not flive:
                C.cl(-op[t]['cmp'], *[op[u][c] for u in range(t + 1, self.m) for c in CMOVS])

    def add_test(self, k):
        C = self.C
        self.tests.append(k)
        st = {r: const_vec(int(self.pre_regs[r][k]), 6) for r in range(self.Rtot)}
        fl = const_vec(int(self.pre_fl[k]), 4)
        e = [int(EXP[j][k]) for j in range(N)]

        def cmpres(A, B):
            unk = C.OR(A[U], B[U])
            lt = C.OR(*[C.AND(A[a], B[b]) for a in range(5) for b in range(5) if a < b])
            gt = C.OR(*[C.AND(A[a], B[b]) for a in range(5) for b in range(5) if a > b])
            eq = C.OR(*[C.AND(A[a], B[a]) for a in range(5)])
            return (lt, eq, gt, unk)

        def eqv(A, B):
            return C.OR(*[C.AND(A[a], B[a]) for a in range(6)])

        def sel_vec(sel, st):
            # one-hot sel over regs: result vector
            out = []
            for v in range(6):
                lits = [(sel[r], st[r][v]) for r in self.regs]
                vals = set(x for _, x in lits)
                if vals == {True}:
                    out.append(True); continue
                if vals == {False}:
                    out.append(False); continue
                z = C.new()
                for sr, x in lits:
                    C.cl(-sr, C.neg(x), z)
                    C.cl(-sr, x, -z)
                out.append(z)
            return tuple(out)

        def cmov_step(take, unk, Vd, Vs):
            uvec = const_vec(U, 6)
            return tuple(C.MUX(take, Vs[v], C.MUX(unk, uvec[v], Vd[v])) for v in range(6))

        for t in range(self.m):
            o = self.op[t]
            Vd = sel_vec(self.d[t], st)
            Vs = sel_vec(self.s[t], st)
            Cf = cmpres(Vd, Vs)
            nfl = tuple(C.MUX(o['cmp'], Cf[f], fl[f]) for f in range(4))
            take = C.OR(o['mov'], *[C.AND(o[c], C.OR(*[fl[f] for f in COND[c]])) for c in CMOVS])
            iscm = C.OR(*[o[c] for c in CMOVS])
            unk = C.AND(iscm, fl[F_U], C.neg(eqv(Vd, Vs)))
            res = cmov_step(take, unk, Vd, Vs)
            nst = dict(st)
            for r in self.regs:
                nst[r] = tuple(C.MUX(self.d[t][r], res[v], st[r][v]) for v in range(6))
            st, fl = nst, nfl
            for j in range(N):
                sv = self.sel.get((j, 'w', t))
                if sv is None:
                    continue
                for r in self.regs:
                    C.cl(-sv, -self.d[t][r], st[r][e[j]])
        for t, (op, d, s) in enumerate(self.suf):
            if op == 'mov':
                st = dict(st); st[d] = st[s]
            elif op == 'cmp':
                fl = cmpres(st[d], st[s])
            else:
                take = C.OR(*[fl[f] for f in COND[op]])
                unk = C.AND(fl[F_U], C.neg(eqv(st[d], st[s])))
                st = dict(st); st[d] = cmov_step(take, unk, st[d], st[s])
            if op != 'cmp':
                for j in range(N):
                    sv = self.sel.get((j, 's', t))
                    if sv is not None:
                        C.cl(-sv, st[d][e[j]])

    def model_prog(self):
        M = set(x for x in self.solver.get_model() if x > 0)
        win = []
        for t in range(self.m):
            o = [x for x in OPS if self.op[t][x] in M][0]
            if o == 'nop':
                continue
            d = [r for r in self.regs if self.d[t][r] in M][0]
            s = [r for r in self.regs if self.s[t][r] in M][0]
            win.append((o, d, s))
        return self.pre + win + self.suf


def check_full(prog, R):
    best, pos, states = out_errors(prog, R)
    return sum(best), best, pos, states


def failing_tests(prog, R, pos, states):
    bad = set()
    for j in range(N):
        if pos[j] is None:
            continue
        t, d = pos[j]
        v = states[t + 1][0][d]
        bad |= set(np.nonzero(v != EXP[j])[0].tolist())
    return sorted(bad)


def window_test(prog, R, i, w, slots, fresh=1, ninit=NINIT, rng=None, verbose=False, tlimit=None):
    """returns ('UNSAT', ntests) or ('HIT', program) or ('TIMEOUT', ntests)"""
    used = sorted(set(r for _, d, s in prog for r in (d, s)) | set(range(N)))
    fr = list(range(max(used) + 1, max(used) + 1 + fresh))
    if SYM:
        st = sim_states(prog[:i], max(used) + 1)[-1][0]
        def dead_after(r):
            for op, d, s in prog[i + w:]:
                if s == r or (op != 'mov' and d == r):
                    return False
                if op == 'mov' and d == r:
                    return True
            return True
        scratch = [r for r in used if r >= N and (st[r] == U).all() and dead_after(r)]
        used = [r for r in used if r not in scratch]
        nf = min(len(scratch), slots)   # judge (a): never fewer temps than removed scratch regs (window writes <= slots regs)
        if nf > fresh:
            fr = list(range(max(used + fr) + 1, max(used + fr) + 1 + nf))
    R = max(fr) + 1
    enc = WinEnc(prog, R, used, i, w, slots, fr)
    rng = rng or random.Random(1)
    init = rng.sample(range(NT), ninit)
    for k in init:
        enc.add_test(k)
    it = 0
    while True:
        it += 1
        ok = enc.solver.solve()
        if not ok:
            r = ('UNSAT', len(enc.tests), enc.C.nv)
            enc.solver.delete()
            return r
        cand = enc.model_prog()
        tot, best, pos, states = check_full(cand, R)
        if tot == 0:
            enc.solver.delete()
            return ('HIT', cand)
        bad = [k for k in failing_tests(cand, R, pos, states) if k not in enc.tests]
        if not bad:  # selector choice differs; add random tests
            bad = [k for k in range(NT) if k not in enc.tests]
        rng.shuffle(bad)
        for k in bad[:6]:
            enc.add_test(k)
        if verbose:
            print('  cegis it', it, 'tests', len(enc.tests), 'err', tot, file=sys.stderr)


def fmt_prog(prog, names):
    def nm(r):
        return names.get(r, 'S%d' % (r + 100))
    return '\n'.join('%s %s, %s' % (op, nm(d), nm(s)) for op, d, s in prog)


if __name__ == '__main__':
    import argparse
    ap = argparse.ArgumentParser()
    ap.add_argument('prog')
    ap.add_argument('-w', type=int, default=8)
    ap.add_argument('-slots', type=int, default=None, help='default w-1')
    ap.add_argument('-i', default=None, help='a:b window starts')
    ap.add_argument('-fresh', type=int, default=1)
    ap.add_argument('-v', action='store_true')
    ap.add_argument('-ninit', type=int, default=24)
    a = ap.parse_args()
    NINIT = a.ninit
    prog, names = parse_regs(read_prog(a.prog))
    K = len(prog)
    R = max(max(d, s) for _, d, s in prog) + 1
    tot, best, pos, _ = check_full(prog, R)
    print('K', K, 'errors', tot, best, file=sys.stderr)
    assert tot == 0
    slots = a.slots if a.slots is not None else a.w - 1
    lo, hi = (0, K - a.w) if a.i is None else map(int, a.i.split(':'))
    for i in range(lo, hi + 1):
        t0 = time.time()
        r = window_test(prog, R, i, a.w, slots, a.fresh, ninit=a.ninit, verbose=a.v)
        if r[0] == 'HIT':
            print('HIT window', i, 'w', a.w, 'len', sum(1 for x in r[1] if x[0] != 'nop'))
            print(fmt_prog(r[1], names))
            sys.stdout.flush()
        else:
            print('window', i, a.w, '->', slots, r[0], 'tests', r[1], 'vars', r[2], '%.1fs' % (time.time() - t0))
            sys.stdout.flush()
