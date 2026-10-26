"""d5-extend: exact SAT search for sort5 programs (M_out, I1, strict 3-valued) of length <= K that contain a fixed
sort4 core (any linearization of its dependency DAG) as a subsequence; the other K-C slots are free (nop allowed).
CEGIS over the 541 weak orders of 5 inputs. Own encoder (independent of agents/sat)."""
import sys, itertools, random, time, argparse
import numpy as np
from pysat.solvers import Solver
from pysat.card import CardEnc, EncType
sys.path.insert(0, '/path/to/repo/agents/team/d5-extend')
from d5lib import weak_orders, dep, rw, parse_key, OPS, MV

FOPS = OPS + ['nop']
NV = 6  # values 0..4, 5 = U (garbage)
UV = 5


class Ext:
    def __init__(self, core, K, n=5, extra=3, solver='cadical195', mode='sub', fix_pos=None, sb=True, relaxed=False):
        self.relaxed = relaxed
        self.n, self.K, self.core = n, K, core
        C = len(core)
        cregs = sorted({x for ins in core for x in ins[1:] if x[0] == 'S'}, key=lambda s: int(s[1:]))
        self.regs = [f'P{i}' for i in range(n)] + cregs + [f'E{i}' for i in range(extra)]
        self.ri = {r: i for i, r in enumerate(self.regs)}
        R = self.R = len(self.regs)
        self.nv = 0
        self.S = Solver(name=solver)
        nw = self.new
        # program vars
        self.op = [[nw() for _ in FOPS] for t in range(K)]
        self.d = [[nw() for _ in range(R)] for t in range(K)]
        self.s = [[nw() for _ in range(R)] for t in range(K)]
        for t in range(K):
            self.eo(self.op[t]); self.eo(self.d[t]); self.eo(self.s[t])
            for r in range(R): self.cl(-self.d[t][r], -self.s[t][r], self.op[t][6])  # d != s unless nop
            # nop: canonical d=s=0
            self.cl(-self.op[t][6], self.d[t][0]); self.cl(-self.op[t][6], self.s[t][0])
        # core placement
        self.x = [[nw() for t in range(K)] for c in range(C)]
        for c in range(C):
            self.eo(self.x[c])
            o, dd, ss = core[c]
            for t in range(K):
                self.cl(-self.x[c][t], self.op[t][FOPS.index(o)])
                self.cl(-self.x[c][t], self.d[t][self.ri[dd]])
                self.cl(-self.x[c][t], self.s[t][self.ri[ss]])
            if c < C - 1 and fix_pos is None:
                pass
        for t in range(K):
            self.amo([self.x[c][t] for c in range(C)])
        # precedence: direct dependencies of core (in its given order)
        for c2 in range(C):
            for c1 in range(c2):
                if dep(core[c1], core[c2]):
                    for t2 in range(K):
                        self.cl(-self.x[c2][t2], *[self.x[c1][t] for t in range(t2)])
        # also keep same-order for identical-typed independent? no (any linearization)
        if fix_pos is not None:
            for c, t in enumerate(fix_pos): self.cl(self.x[c][t])
        # symmetry breaking (commutation): a free slot directly before a core slot must conflict with it;
        # two adjacent independent core instructions appear in index order.
        if sb and fix_pos is None:
            iscore = [nw() for t in range(K)]
            for t in range(K):
                self.cl(-iscore[t], *[self.x[c][t] for c in range(C)])
                for c in range(C): self.cl(-self.x[c][t], iscore[t])
            op = self.op
            for t in range(K - 1):
                # aux: free instr at t writes reg r / reads reg r
                wr = [nw() for r in range(R)]; rd = [nw() for r in range(R)]
                for r in range(R):
                    self.cl(-wr[r], self.d[t][r]); self.cl(-wr[r], -op[t][1]); self.cl(-wr[r], -op[t][6])
                    self.cl(-rd[r], self.s[t][r], self.d[t][r]); self.cl(-rd[r], -op[t][6])
                    self.cl(-rd[r], self.s[t][r], op[t][1], op[t][2], op[t][3], op[t][4], op[t][5])
                for c in range(C):
                    rc, wc = rw(core[c])
                    lits = [wr[self.ri[r]] for r in (rc | wc) if r != 'F']
                    lits += [rd[self.ri[r]] for r in wc if r != 'F']
                    if 'F' in rc or 'F' in wc: lits.append(op[t][1])
                    if 'F' in wc: lits += [op[t][k] for k in range(2, 6)]
                    self.cl(-self.x[c][t + 1], iscore[t], *lits)
                for c1 in range(C):
                    for c2 in range(c1 + 1, C):
                        if not dep(core[c1], core[c2]):
                            self.cl(-self.x[c2][t], -self.x[c1][t + 1])
        # free slots: symmetry breaking -- nops only at end
        for t in range(K - 1):
            self.cl(-self.op[t][6], self.op[t + 1][6])
        # E registers canonical: E_i used (as d or s) only if E_{i-1} used at an earlier or same slot
        e0 = n + len(cregs)
        self.used = [[nw() for t in range(K)] for r in range(R)]  # used[r][t]: touched in slots <= t
        for r in range(e0, R):
            for t in range(K):
                prev = [self.used[r][t - 1]] if t else []
                self.cl(-self.used[r][t], self.d[t][r], self.s[t][r], *prev)
                self.cl(-self.d[t][r], self.used[r][t]); self.cl(-self.s[t][r], self.used[r][t])
                if t: self.cl(-self.used[r][t - 1], self.used[r][t])
                if r > e0: self.cl(-self.used[r][t], self.used[r - 1][t])
        # outputs: o[j][t][r], t in 0..K (state after t slots)
        self.o = [[[nw() for r in range(R)] for t in range(K + 1)] for j in range(n)]
        for j in range(n):
            self.eo([v for row in self.o[j] for v in row])
            # output snapshot right after the instruction that wrote the register (or initial state)
            for t in range(1, K + 1):
                for r in range(R):
                    self.cl(-self.o[j][t][r], self.d[t - 1][r]); self.cl(-self.o[j][t][r], -self.op[t - 1][1])
                    self.cl(-self.o[j][t][r], -self.op[t - 1][6])
        # free cmp: operands in index order (cmp b,a == cmp a,b with mirrored cmovs; I1 has all 4)
        coreslot = lambda t: [self.x[c][t] for c in range(C)]
        for t in range(K if C == 0 else 0):  # unsound with a fixed core (core cmovs read free flags)
            for r1 in range(R):
                for r2 in range(r1):
                    self.cl(-self.op[t][1], -self.d[t][r1], -self.s[t][r2], *coreslot(t))
        for t in range(K):
            # two cmps in a row: the first is dead (sound)
            if t < K - 1:
                self.cl(-self.op[t][1], -self.op[t + 1][1], *coreslot(t))
        self.W = weak_orders(n)
        self.exp = np.sort(self.W, axis=1)
        self.tests = []

    def new(self):
        self.nv += 1
        return self.nv

    def cl(self, *l):
        self.S.add_clause(list(l))

    def amo(self, lits):
        if len(lits) <= 6:
            for a, b in itertools.combinations(lits, 2): self.cl(-a, -b)
        else:
            enc = CardEnc.atmost(lits, 1, top_id=self.nv, encoding=EncType.seqcounter)
            self.nv = max(self.nv, enc.nv)
            for c in enc.clauses: self.cl(*c)

    def eo(self, lits):
        self.cl(*lits); self.amo(lits)

    def onehot(self, k):
        v = [self.new() for _ in range(k)]
        self.eo(v)
        return v

    def add_test(self, i):
        self.tests.append(i)
        w = self.W[i]; n, K, R = self.n, self.K, self.R
        val = [[None] * R for _ in range(K + 1)]
        T = lambda: True
        # initial: constants -> use fixed literal arrays: represent as python list of literals or True/False
        tv = self.new(); self.cl(tv)  # TRUE literal
        F = -tv
        for r in range(R):
            v = w[r] if r < n else UV
            val[0][r] = [tv if k == v else F for k in range(NV)]
        fl = [tv, F, F, F] if self.relaxed else [F, F, F, tv]  # eq lt gt U ; initial U (strict) / eq (relaxed)
        for t in range(K):
            op, d, s = self.op[t], self.d[t], self.s[t]
            dv = self.onehot(NV); sv = self.onehot(NV)
            for r in range(R):
                for k in range(NV):
                    self.cl(-d[r], -val[t][r][k], dv[k])
                    self.cl(-s[r], -val[t][r][k], sv[k])
            # new flag
            nf = self.onehot(4)
            iscmp = op[1]
            for f in range(4):  # not cmp: keep
                self.cl(iscmp, -fl[f], nf[f])
            for a in range(NV):
                for b in range(NV):
                    f = 3 if (a == UV or b == UV) and not self.relaxed else (1 if a < b else 2 if a > b else 0)
                    self.cl(-iscmp, -dv[a], -sv[b], nf[f])
            # written value
            wv = self.onehot(NV)
            for k in range(NV):
                self.cl(-op[0], -sv[k], wv[k])           # mov
                self.cl(-op[1], -dv[k], wv[k])           # cmp
                self.cl(-op[6], -dv[k], wv[k])           # nop
            for oi in range(2, 6):
                m = MV[FOPS[oi]]
                for f in range(3):
                    src = sv if m[f] else dv
                    for k in range(NV):
                        self.cl(-op[oi], -fl[f], -src[k], wv[k])
                for a in range(NV):
                    for b in range(NV):
                        self.cl(-op[oi], -fl[3], -dv[a], -sv[b], wv[a if a == b else UV])
            nxt = []
            for r in range(R):
                vr = self.onehot(NV)
                for k in range(NV):
                    self.cl(-d[r], -wv[k], vr[k])
                    self.cl(d[r], -val[t][r][k], vr[k])
                nxt.append(vr)
            val[t + 1] = nxt
            fl = nf
        ex = self.exp[i]
        for j in range(n):
            for t in range(K + 1):
                for r in range(R):
                    self.cl(-self.o[j][t][r], val[t][r][ex[j]])

    def model_prog(self, m):
        ms = set(l for l in m if l > 0)
        prog = []
        for t in range(self.K):
            o = [k for k in range(7) if self.op[t][k] in ms][0]
            if o == 6: continue
            d = [r for r in range(self.R) if self.d[t][r] in ms][0]
            s = [r for r in range(self.R) if self.s[t][r] in ms][0]
            prog.append((FOPS[o], self.regs[d], self.regs[s]))
        return prog


def sim_full(prog, n=5):
    """strict 3-valued; returns (list of failing test idx, out placement)."""
    W = weak_orders(n); T = len(W); Uv = 99
    regs = {f'P{i}': W[:, i].astype(np.int16) for i in range(n)}
    fl = np.full(T, 3)
    snaps = [dict(regs)]
    for o, d, s in prog:
        dv = regs.get(d, np.full(T, Uv)); sv = regs.get(s, np.full(T, Uv))
        if o == 'mov': regs[d] = sv.copy()
        elif o == 'cmp':
            fl = np.where((dv == Uv) | (sv == Uv), 3, np.where(dv < sv, 1, np.where(dv > sv, 2, 0)))
        else:
            m = MV[o]
            mv = ((fl == 0) & m[0]) | ((fl == 1) & m[1]) | ((fl == 2) & m[2])
            un = (fl == 3) & (dv != sv)
            regs[d] = np.where(mv, sv, np.where(un, Uv, dv))
        snaps.append(dict(regs))
    exp = np.sort(W, axis=1)
    bad = set(); outs = []
    for j in range(n):
        best = None
        for t, sn in enumerate(snaps):
            for r, v in sn.items():
                e = np.nonzero(v != exp[:, j])[0]
                if best is None or len(e) < len(best[0]): best = (e, t, r)
        outs.append((best[1], best[2]))
        if len(best[0]): bad.add(int(best[0][0]))
    return sorted(bad), outs


def fmt(prog, outs):
    lines = []
    for t in range(len(prog) + 1):
        if t: lines.append('%s %s, %s' % prog[t - 1])
        for j, (tt, r) in enumerate(outs):
            if tt == t: lines.append(f'out {j}, {r}')
    return '\n'.join(lines) + '\n'


def solve(core, K, extra=3, seed=0, verbose=False, init=12, tlimit=None, fix_pos=None, sb=True, relaxed=False):
    e = Ext(core, K, extra=extra, fix_pos=fix_pos, sb=sb, relaxed=relaxed)
    rng = random.Random(seed)
    W = e.W
    perms = [i for i in range(len(W)) if len(set(W[i])) == 5]
    for i in rng.sample(perms, init): e.add_test(i)
    t0 = time.time()
    while True:
        ok = e.S.solve()
        if not ok:
            return 'UNSAT', len(e.tests), time.time() - t0, None
        prog = e.model_prog(e.S.get_model())
        bad, outs = sim_full(prog)
        if not bad:
            return 'SAT', len(e.tests), time.time() - t0, fmt(prog, outs)
        nb = [b for b in bad if b not in e.tests]
        e.add_test(rng.choice(nb))
        if verbose: print('tests', len(e.tests), 'time %.1f' % (time.time() - t0), flush=True)


if __name__ == '__main__':
    ap = argparse.ArgumentParser()
    ap.add_argument('--key'); ap.add_argument('--K', type=int, default=31); ap.add_argument('--extra', type=int, default=3)
    ap.add_argument('--suffix', action='store_true')
    a = ap.parse_args()
    core = parse_key(a.key)
    print(solve(core, a.K, a.extra, verbose=True, fix_pos=list(range(len(core))) if a.suffix else None))
