#!/usr/bin/env python3
"""d1-skeleton: routing SAT for a FIXED cmp skeleton (sort5, M_out, I1).

Skeleton = sequence of c flag functions F_j: type -> {l,e,g}. Program: k steps (nop allowed at the end),
the j-th cmp must give flags F_j on every type in the test set. Solver chooses positions of cmps, all
cmov/mov instructions, registers, and output snapshots.
Normal form (sound, length-preserving): no cmov before the first cmp; the m-th mov writes fresh scratch S_m;
no instruction reads an untouched scratch; cmov never writes an untouched scratch (it would be a mov).
Hence no garbage value ever exists, values are ranks 0..n-1. Test set: permutations (sound for UNSAT) plus
optional extra weak-order types (CEGIS).
"""
import itertools, subprocess, sys, os, tempfile, argparse

N = 5
OPS = ['mov', 'cmp', 'cmovl', 'cmovle', 'cmovg', 'cmovge', 'nop']
COND = {'cmovl': 'l', 'cmovle': 'le', 'cmovg': 'g', 'cmovge': 'ge'}


def ev_formula(f, x):
    """f = 'a|b|..' with each term a string of digits = max over terms of min over digits."""
    return max(min(x[int(ch)] for ch in term) for term in f.split('|'))


def flag(a, b):
    return 'l' if a < b else 'g' if a > b else 'e'


def all_weak(n=N):
    out = []
    for v in itertools.product(range(n), repeat=n):
        if set(v) == set(range(max(v) + 1)):
            out.append(v)
    return out


def perms(n=N):
    return [tuple(p) for p in itertools.permutations(range(n))]


class Enc:
    def __init__(self, k, F, types, nscr=None, maxcmp=None):
        self.k, self.F, self.types = k, F, types
        self.c = len(F)
        self.nv = 0
        self.cls = []
        c = self.c
        if nscr is None:
            nscr = max(0, k - 2 * c)  # each cmp needs >= 1 cmov
        self.nscr = nscr
        self.R = N + nscr
        self.build()

    def new(self):
        self.nv += 1
        return self.nv

    def cl(self, *l):
        out = []
        for x in l:
            if x is True:
                return
            if x is False:
                continue
            out.append(x)
        assert out, 'empty clause'
        self.cls.append(out)

    def eo(self, lits):
        self.cl(*lits)
        self.amo(lits)

    def amo(self, lits):
        if len(lits) <= 6:
            for a, b in itertools.combinations(lits, 2):
                self.cl(-a, -b)
        else:
            prev = None
            for i, l in enumerate(lits):
                if i < len(lits) - 1:
                    s = self.new()
                    self.cl(-l, s)
                    if prev:
                        self.cl(-prev, s)
                        self.cl(-prev, -l)
                    prev = s
                else:
                    self.cl(-prev, -l)

    def counter(self, inc, top):
        """ge[t][j] (t=0..k, j=0..top+1): at least j of inc[0..t-1] true; ge[.][top+1] forced false."""
        k = self.k
        ge = [[True] + [False] * (top + 1)]
        for t in range(k):
            row = [True]
            for j in range(1, top + 2):
                v = self.new()
                a, b = ge[t][j], ge[t][j - 1]
                # v <-> a or (b and inc)
                self.cl(-v, a, b) if a is not True else None
                self.cl(-v, a, inc[t])
                self.cl(v, self.neg(a))
                self.cl(v, self.neg(b), -inc[t])
                row.append(v)
            ge.append(row)
        for t in range(k + 1):
            self.cl(self.neg(ge[t][top + 1]))
        return ge

    @staticmethod
    def neg(x):
        if x is True:
            return False
        if x is False:
            return True
        return -x

    def build(self):
        k, R, c, T = self.k, self.R, self.c, len(self.types)
        self.op = [{o: self.new() for o in OPS} for t in range(k)]
        for t in range(k):
            self.eo(list(self.op[t].values()))
            if t + 1 < k:
                self.cl(-self.op[t]['nop'], self.op[t + 1]['nop'])
        self.dst = [[self.new() for r in range(R)] for t in range(k)]
        self.src = [[self.new() for r in range(R)] for t in range(k)]
        for t in range(k):
            self.eo(self.dst[t])
            self.eo(self.src[t])
            for r in range(R):
                self.cl(-self.dst[t][r], -self.src[t][r])
        iscmp = [self.op[t]['cmp'] for t in range(k)]
        ismov = [self.op[t]['mov'] for t in range(k)]
        iscmov = []
        for t in range(k):
            v = self.new()
            cm = [self.op[t][o] for o in COND]
            self.cl(-v, *cm)
            for x in cm:
                self.cl(v, -x)
            iscmov.append(v)
        self.cge = self.counter(iscmp, c)
        self.mge = self.counter(ismov, self.nscr)
        self.cl(self.cge[k][c])  # exactly c cmps
        # register touch rules
        for t in range(k):
            for s in range(self.nscr):
                r = N + s
                touched = self.mge[t][s + 1]
                self.cl(-self.src[t][r], touched)
                # mov number s writes scratch s
                exact = [self.mge[t][s], self.neg(self.mge[t][s + 1])]
                self.cl(-ismov[t], self.neg(exact[0]), self.neg(exact[1]), self.dst[t][r])
                self.cl(-iscmov[t], -self.dst[t][r], touched)
                self.cl(-iscmp[t], -self.dst[t][r], touched)
            for r in range(N):
                self.cl(-ismov[t], -self.dst[t][r])
            # no cmov before first cmp
            self.cl(-iscmov[t], self.cge[t][1])
        # values
        self.val = []
        v0 = []
        for r in range(R):
            row = []
            for ti, ty in enumerate(self.types):
                if r < N:
                    row.append([u == ty[r] for u in range(N)])
                else:
                    row.append([False] * N)  # untouched scratch: never read
            v0.append(row)
        self.val.append(v0)
        for t in range(k):
            cur = self.val[t]
            # dv / sv
            dv = [[self.new() for u in range(N)] for ti in range(T)]
            sv = [[self.new() for u in range(N)] for ti in range(T)]
            for ti in range(T):
                self.amo(dv[ti])
                self.amo(sv[ti])
                for r in range(R):
                    for u in range(N):
                        x = cur[r][ti][u]
                        if x is False:
                            continue
                        self.cl(-self.dst[t][r], self.neg(x), dv[ti][u])
                        self.cl(-self.src[t][r], self.neg(x), sv[ti][u])
            # cmp constraint
            for j in range(c):
                ex = [self.cge[t][j], self.neg(self.cge[t][j + 1])]
                for ti, ty in enumerate(self.types):
                    f = self.F[j][ti]
                    for u in range(N):
                        ok = [sv[ti][w] for w in range(N) if flag(u, w) == f]
                        self.cl(-iscmp[t], self.neg(ex[0]), self.neg(ex[1]), -dv[ti][u], *ok)
            # take / mv
            nxt = []
            mv = []
            for ti in range(T):
                m = self.new()
                mv.append(m)
                self.cl(-ismov[t], m)
                self.cl(-self.op[t]['cmp'], -m)
                self.cl(-self.op[t]['nop'], -m)
                for j in range(1, c + 1):
                    ex = [self.cge[t][j], self.neg(self.cge[t][j + 1]) if j + 1 <= c + 1 else True]
                    f = self.F[j - 1][ti]
                    for o, cond in COND.items():
                        take = f in cond if f != 'e' else ('e' in cond)
                        take = (f == 'l' and 'l' in cond) or (f == 'g' and 'g' in cond) or (f == 'e' and cond.endswith('e'))
                        self.cl(self.neg(ex[0]), self.neg(ex[1]), -self.op[t][o], m if take else -m)
            for r in range(R):
                row = []
                for ti in range(T):
                    nvv = [self.new() for u in range(N)]
                    self.amo(nvv)
                    if r >= N:
                        for u in range(N):
                            self.cl(-nvv[u], self.mge[t + 1][r - N + 1])
                    for u in range(N):
                        self.cl(-self.dst[t][r], -mv[ti], -sv[ti][u], nvv[u])
                        x = cur[r][ti][u]
                        if x is not False:
                            self.cl(self.dst[t][r], self.neg(x), nvv[u])
                            self.cl(mv[ti], self.neg(x), nvv[u])
                    row.append(nvv)
                nxt.append(row)
            self.val.append(nxt)
        # outputs: snapshot after step t (t=1..k) in register r
        self.snap = {}
        for j in range(N):
            lits = []
            for t in range(1, k + 1):
                for r in range(R):
                    ok = True
                    for ti, ty in enumerate(self.types):
                        if self.val[t][r][ti][sorted(ty)[j]] is False:
                            ok = False
                            break
                    if not ok:
                        continue
                    s = self.new()
                    lits.append(s)
                    self.snap[(j, t, r)] = s
                    for ti, ty in enumerate(self.types):
                        self.cl(-s, self.val[t][r][ti][sorted(ty)[j]])
            self.cl(*lits)

    def dimacs(self, fn):
        with open(fn, 'w') as f:
            f.write('p cnf %d %d\n' % (self.nv, len(self.cls)))
            for c in self.cls:
                f.write(' '.join(map(str, c)) + ' 0\n')

    def decode(self, model):
        def tr(l):
            return model.get(abs(l), False) if l > 0 else not model.get(abs(l), False)
        rn = lambda r: 'P%d' % r if r < N else 'S%d' % (r - N)
        prog = []
        outs = {}
        for (j, t, r), s in self.snap.items():
            if tr(s) and j not in outs:
                outs[j] = (t, r)
        for t in range(self.k):
            o = [x for x in OPS if tr(self.op[t][x])][0]
            if o != 'nop':
                d = [r for r in range(self.R) if tr(self.dst[t][r])][0]
                s = [r for r in range(self.R) if tr(self.src[t][r])][0]
                prog.append('%s %s, %s' % (o, rn(d), rn(s)))
            for j in sorted(outs):
                if outs[j][0] == t + 1:
                    prog.append('out %d, %s' % (j, rn(outs[j][1])))
        return prog


def solve(enc, solver='kissat', timeout=None, tag='x'):
    d = os.environ.get('RSAT_TMP', '/tmp')
    fn = os.path.join(d, 'rsat_%s_%d.cnf' % (tag, os.getpid()))
    enc.dimacs(fn)
    cmd = ['bin/' + solver, '-q', fn] if solver == 'kissat' else ['bin/' + solver, '-q', fn]
    if timeout:
        cmd = ['timeout', str(timeout)] + cmd
    p = subprocess.run(cmd, capture_output=True, text=True)
    os.unlink(fn)
    st, model = None, {}
    for line in p.stdout.splitlines():
        if line.startswith('s '):
            st = line[2:].strip()
        elif line.startswith('v '):
            for x in line[2:].split():
                x = int(x)
                if x:
                    model[abs(x)] = x > 0
    return st, model


def F_from_formulas(skel, types):
    F = []
    for a, b in skel:
        F.append([flag(ev_formula(a, ty), ev_formula(b, ty)) for ty in types])
    return F


def normalize(lines):
    """convert an M_out program to rsat normal form (fresh scratch per mov; cmov into untouched -> mov)."""
    cur = {'P%d' % i: 'P%d' % i for i in range(N)}
    nm = 0
    out = []
    for line in lines:
        line = line.split('#')[0].strip()
        if not line:
            continue
        op, rest = line.split(None, 1)
        d, s = [x.strip() for x in rest.split(',')]
        if op == 'out':
            out.append('out %s, %s' % (d, cur[s]))
            continue
        if op == 'cmp':
            out.append('cmp %s, %s' % (cur[d], cur[s]))
            continue
        if op == 'mov' or d not in cur:
            cur[d] = 'S%d' % nm
            nm += 1
            out.append('mov %s, %s' % (cur[d], cur[s]))
            continue
        out.append('%s %s, %s' % (op, cur[d], cur[s]))
    return out


def fix(enc, prog):
    """unit clauses forcing enc to the given normal-form program (outs ignored)."""
    ins = [l for l in prog if not l.startswith('out')]
    reg = lambda x: int(x[1:]) if x[0] == 'P' else N + int(x[1:])
    for t in range(enc.k):
        if t >= len(ins):
            enc.cl(enc.op[t]['nop'])
            continue
        op, rest = ins[t].split(None, 1)
        d, s = [x.strip() for x in rest.split(',')]
        enc.cl(enc.op[t][op])
        enc.cl(enc.dst[t][reg(d)])
        enc.cl(enc.src[t][reg(s)])
