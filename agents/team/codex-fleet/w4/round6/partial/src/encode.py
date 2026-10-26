"""SAT encoder for "is there a program of length k that sorts n inputs" in the relaxed model of
shared/MODEL.md section 2 (scratch = T > all inputs, initial flags = eq), restricted to a set of order types.

UNSAT for a subset of order types => UNSAT for all order types (each type adds only constraints).

Rules (symmetry breaking / normal form, each one separately on/off; proofs: RULES.md, review: theory):
  canon : scratch registers are numbered in order of first touch (dst before src inside one instruction)
  comm  : two adjacent independent instructions are in lexicographic order (unless both touch a fresh scratch)
  dead  : no write whose value is never read (needs nop mode); no mov/cmov r, r
  flags : every cmp is read by a cmov before the next cmp / the end; no cmov before the first cmp (needs nop mode)
  pcanon: input registers P are numbered by first touch (only snap/free outputs: inputs are interchangeable there)
  cmpord: cmp A, B only if index(A) < index(B); no cmp r, r (needs nop mode)
  movfresh: (snap/free, needs canon + nop) every mov writes an untouched scratch and reads a touched register
  snapcmov: (snap, n >= 2) every output snapshot is the slot of a cmov step
  hcmp  : (snap, needs flags + snapcmov) suffix counts: #cmp <= #cmov, #undone outputs <= #cmov, #cmp + max(..) <=
          remaining steps; with add_class_cuts() (permutations): class of size > 2^m at step i => >= m+1 cmps remain
Cardinality cuts (lemmas, not rules): mincmp (#cmp >= c; theory L7: ceil(log2 n!) on permutations), mincmov.
Nop mode ("<= k"): opcode nop allowed, nops only at the end.
"""
import itertools, sys

I0 = ['mov', 'cmp', 'cmovl', 'cmovg']
I1 = I0 + ['cmovle', 'cmovge']
ALL_RULES = ('canon', 'pcanon', 'comm', 'dead', 'flags', 'cmpord', 'movfresh', 'snapcmov', 'hcmp')


class Enc:
    def __init__(self, n, k, R=None, iset='I0', outmode='fixed', rules=(), nop=False, mincmp=0, mincmov=0, amo='seq', cmpeq=None, maxmov=None, blocks=None):
        self.n, self.k = n, k
        self.R = R if R is not None else n + k
        self.ops = list(I0 if iset == 'I0' else I1) + (['nop'] if nop else [])
        self.outmode, self.rules, self.nop = outmode, set(rules), nop
        assert self.rules <= set(ALL_RULES), rules
        if self.rules & {'dead', 'flags', 'cmpord', 'movfresh', 'hcmp'}:
            assert nop, 'rules dead/flags remove instructions: they need nop mode (<= k)'
        self.mincmp, self.mincmov, self.cmpeq, self.maxmov = mincmp, mincmov, cmpeq, maxmov
        self.blocks = blocks  # case split: exactly blocks[j-1] cmovs between the j-th cmp and the next one
        self.amo = amo  # 'seq': pairwise up to 6 literals, else sequential counter; 'pairwise': always pairwise
        self.nvars = 0
        self.clauses = []
        self.types = []
        self.traces = []
        self._prog_vars()

    # ---- basic helpers -------------------------------------------------------------------------
    def new(self):
        self.nvars += 1
        return self.nvars

    def cl(self, *lits):
        """Add a clause; literals may be True/False constants (simplified away)."""
        out = []
        for l in lits:
            if l is True:
                return
            if l is False:
                continue
            out.append(l)
        if not out:
            raise RuntimeError('empty clause added (trivially UNSAT encoding)')
        self.clauses.append(out)

    def exactly_one(self, lits):
        lits = [l for l in lits if l is not False]
        assert lits
        if any(l is True for l in lits):
            assert len(lits) == 1
            return
        self.cl(*lits)
        if len(lits) <= 6 or self.amo == 'pairwise':
            for a, b in itertools.combinations(lits, 2):
                self.cl(-a, -b)
        else:  # sequential counter AMO
            prev = None
            for idx, l in enumerate(lits):
                if idx < len(lits) - 1:
                    sv = self.new()
                    self.cl(-l, sv)
                    if prev is not None:
                        self.cl(-prev, sv)
                        self.cl(-prev, -l)
                    prev = sv
                else:
                    self.cl(-prev, -l)

    def atleast(self, lits, c):
        """at least c of lits are true (sequential counter, only-if direction)."""
        prev = [True] + [False] * c  # prev[j]: at least j of the lits so far
        for x in lits:
            cur = [True]
            for j in range(1, c + 1):
                if prev[j - 1] is False:
                    cur.append(False)
                    continue
                v = self.new()
                self.cl(-v, prev[j], x)
                self.cl(-v, prev[j], prev[j - 1])
                cur.append(v)
            prev = cur
        self.cl(prev[c])

    @staticmethod
    def neg(l):
        if l is True: return False
        if l is False: return True
        return -l

    # ---- program variables ---------------------------------------------------------------------
    def _prog_vars(self):
        n, k, R = self.n, self.k, self.R
        canon = 'canon' in self.rules
        nsc = R - n
        # maximal scratch index usable as dst / src at step i under canon (loose bound: m(i) = 2i+1)
        self.dmax, self.smax = [], []
        for i in range(k):
            if canon:
                self.dmax.append(min(nsc - 1, 2 * i))
                self.smax.append(min(nsc - 1, 2 * i + 1))
            else:
                self.dmax.append(nsc - 1)
                self.smax.append(nsc - 1)
        self.op = [{o: self.new() for o in self.ops} for i in range(k)]
        self.d = [[self.new() if r < n or r - n <= self.dmax[i] else False for r in range(R)] for i in range(k)]
        self.s = [[self.new() if r < n or r - n <= self.smax[i] else False for r in range(R)] for i in range(k)]
        for i in range(k):
            self.exactly_one(list(self.op[i].values()))
            self.exactly_one(self.d[i])
            self.exactly_one(self.s[i])
        if self.nop:
            for i in range(k):
                nop = self.op[i]['nop']
                if i + 1 < k:
                    self.cl(-nop, self.op[i + 1]['nop'])
                self.cl(-nop, self.d[i][0])
                self.cl(-nop, self.s[i][0])
        # output map (free mode)
        if self.outmode == 'free':
            self.out = [[self.new() for r in range(R)] for j in range(n)]
            for j in range(n):
                self.exactly_one(self.out[j])
            for r in range(R):
                for a, b in itertools.combinations(range(n), 2):
                    self.cl(-self.out[a][r], -self.out[b][r])
        if self.outmode == 'snap':
            # slot r < n: input P_r at time 0; slot n + i: the value written by step i (just after step i)
            self.osnap = [[self.new() for x in range(n + k)] for j in range(n)]
            for j in range(n):
                self.exactly_one(self.osnap[j])
            for x in range(n + k):
                for a, b in itertools.combinations(range(n), 2):
                    self.cl(-self.osnap[a][x], -self.osnap[b][x])
            self.snapped = []
            for i in range(k):
                v = self.new()
                for j in range(n):
                    self.cl(-self.osnap[j][n + i], v)
                    if self.nop:
                        self.cl(-self.osnap[j][n + i], -self.op[i]['nop'])
                    self.cl(-self.osnap[j][n + i], -self.op[i]['cmp'])
                self.cl(-v, *[self.osnap[j][n + i] for j in range(n)])
                self.snapped.append(v)
        if self.rules & {'canon', 'pcanon'}:
            self._rule_canon()
        if 'cmpord' in self.rules:
            self._rule_cmpord()
        if 'movfresh' in self.rules:
            self._rule_movfresh()
        if 'snapcmov' in self.rules:
            assert self.outmode == 'snap' and n >= 2
            cm = ['cmovl', 'cmovg', 'cmovle', 'cmovge']
            for j in range(n):
                for r in range(n):
                    self.cl(-self.osnap[j][r])
                for i in range(k):
                    self.cl(-self.osnap[j][n + i], *self.is_op(i, cm))
        if 'hcmp' in self.rules:
            assert self.outmode == 'snap' and 'snapcmov' in self.rules and 'flags' in self.rules
            self._counting_cuts()
            if self.cmpeq is not None:  # case split: exactly c cmps (bounds' SORT5_SPLIT)
                self.cl(self.Q[0][self.cmpeq])
                if self.cmpeq + 1 <= k:
                    self.cl(self.neg(self.Q[0][self.cmpeq + 1]))
        if self.mincmp:
            self.atleast([self.op[i]['cmp'] for i in range(k)], self.mincmp)
        if self.blocks is not None:
            self._blocks()
            self._forced_pattern()
        if self.maxmov is not None:  # #mov <= maxmov  <=>  #(non-mov steps) >= k - maxmov
            self.atleast([-self.op[i]['mov'] for i in range(k)], k - self.maxmov)
        if self.mincmov:
            self.atleast([l for i in range(k) for l in self.is_op(i, ['cmovl', 'cmovg', 'cmovle', 'cmovge'])],
                         self.mincmov)
        if 'dead' in self.rules:
            self._rule_dead()
        if 'flags' in self.rules:
            self._rule_flags()
        if 'comm' in self.rules:
            self._rule_comm()

    def is_op(self, i, names):
        return [self.op[i][o] for o in names if o in self.op[i]]

    def _canon_class(self, regs):
        """Registers regs (in order) are numbered by first touch (dst before src inside one step).
        Returns per step the list of 'fresh touch' literals (g -> step touches a reg of regs untouched before)."""
        k = self.k
        m = len(regs)
        touched = [[False] * m]  # touched[i][j]: regs[j] touched by some step < i
        for i in range(k):
            row = []
            for j, r in enumerate(regs):
                a, b = self.d[i][r], self.s[i][r]
                prev = touched[i][j]
                if prev is False and a is False and b is False:
                    row.append(False)
                    continue
                t = self.new()
                self.cl(self.neg(prev), t)
                self.cl(self.neg(a), t)
                self.cl(self.neg(b), t)
                self.cl(-t, prev, a, b)
                row.append(t)
            touched.append(row)
        for i in range(k):
            for j in range(1, m):
                self.cl(self.neg(self.d[i][regs[j]]), touched[i][j - 1])
                self.cl(self.neg(self.s[i][regs[j]]), touched[i][j - 1], self.d[i][regs[j - 1]])
        fresh = []
        for i in range(k):
            gs = []
            for j, r in enumerate(regs):
                a, b = self.d[i][r], self.s[i][r]
                if a is False and b is False:
                    continue
                g = self.new()
                self.cl(-g, self.neg(touched[i][j]))
                self.cl(-g, a, b)
                self.cl(self.neg(a), touched[i][j], g)
                self.cl(self.neg(b), touched[i][j], g)
                gs.append(g)
            fresh.append(gs)
        return touched, fresh

    def _rule_canon(self):
        n, k, R = self.n, self.k, self.R
        classes = []
        if 'canon' in self.rules:
            classes.append(list(range(n, R)))
        if 'pcanon' in self.rules:
            assert self.outmode in ('snap', 'free'), 'pcanon (input renaming) is only valid for snap/free outputs'
            classes.append(list(range(n)))
        fresh = [[] for i in range(k)]
        for regs in classes:
            touched, fr = self._canon_class(regs)
            if regs[0] >= n:
                self.touched = touched
            for i in range(k):
                fresh[i] += fr[i]
        # ft[i] <-> step i touches some register (of a canonical class) untouched before
        self.ft = []
        for i in range(k):
            f = self.new()
            self.cl(-f, *fresh[i]) if fresh[i] else self.cl(-f)
            for g in fresh[i]:
                self.cl(-g, f)
            self.ft.append(f)

    def suffix_counter(self, lits_per_step, cmax):
        """C[i][c] <-> at least c of the step literals in steps >= i are true (exact), c = 0..cmax."""
        k = self.k
        C = [None] * (k + 1)
        C[k] = [True] + [False] * cmax
        for i in range(k - 1, -1, -1):
            x = lits_per_step[i]
            row = [True]
            for c in range(1, cmax + 1):
                a, b = C[i + 1][c], C[i + 1][c - 1]
                if a is False and (b is False or x is False):
                    row.append(False)
                    continue
                v = self.new()
                # v <-> a or (x and b)
                self.cl(self.neg(a), v)
                self.cl(self.neg(x), self.neg(b), v)
                self.cl(-v, a, x)
                self.cl(-v, a, b)
                row.append(v)
            C[i] = row
        return C

    def _counting_cuts(self):
        """hcmp (part 1, implied by rules flags + snapcmov): with Q = #cmp, M = #cmov, W = #outputs with slot >= i,
        all in steps >= i: Q <= M, W <= M, Q + max(Q, W) <= k - i."""
        n, k = self.n, self.k
        cm = ['cmovl', 'cmovg', 'cmovle', 'cmovge']
        cmax = k
        cmpl = [self.op[i]['cmp'] for i in range(k)]
        cmovl = []
        for i in range(k):
            ls = self.is_op(i, cm)
            v = self.new()
            for l in ls:
                self.cl(-l, v)
            self.cl(-v, *ls)
            cmovl.append(v)
        self.Q = self.suffix_counter(cmpl, cmax)
        self.M = self.suffix_counter(cmovl, cmax)
        self.W = self.suffix_counter(self.snapped, n)
        for i in range(k + 1):
            rem = k - i
            for c in range(1, cmax + 1):
                self.cl(self.neg(self.Q[i][c]), self.M[i][c])
            for u in range(1, n + 1):
                self.cl(self.neg(self.W[i][u]), self.M[i][u] if u <= cmax else False)
            for c in range(0, cmax + 1):
                for u in range(0, n + 1):
                    if c + max(c, u) > rem:
                        self.cl(self.neg(self.Q[i][c]), self.neg(self.W[i][u]))

    def add_class_cuts(self, steps=None, subset=None):
        """hcmp (part 2, lemma = enum H1 / theory L7 per step): call after all (permutation) types are added.
        E(i,p,q) is forced true when p, q have equal content in every register, equal flags before step i and equal
        content in every snapshot slot < i. If >= 2^m other types are in p's class at step i, then >= m+1 cmps
        remain (Q[i][m+1]).
        steps: cut only at steps i < steps; subset: indices of the types used for the classes. Both only drop cuts
        (a class inside a subset is a subset of the true class), so they stay sound; they make the CNF smaller."""
        assert 'hcmp' in self.rules
        n, R = self.n, self.R
        k = self.k if steps is None else min(steps, self.k)
        idx = list(range(len(self.types))) if subset is None else list(subset)
        assert all(len(set(self.types[t])) == n for t in idx), 'class cut needs permutations only'
        E = {}
        for ai in range(len(idx)):
            for bi in range(ai + 1, len(idx)):
                p, q = idx[ai], idx[bi]
                (tp, nvp), (tq, nvq) = self.traces[p], self.traces[q]
                G = True
                for i in range(k):
                    valp, ltp, gtp = tp[i]
                    valq, ltq, gtq = tq[i]
                    if i > 0:
                        # G_i <- G_{i-1} and (not snapped[i-1] or nv equal at step i-1)
                        ne = self.new()
                        for u in range(n + 1):
                            self.cl(-nvp[i - 1][u], -nvq[i - 1][u], ne)
                        g = self.new()
                        self.cl(self.neg(G), self.snapped[i - 1], g)
                        self.cl(self.neg(G), -ne, g)
                        G = g
                    lits = [self.neg(G)]
                    for r in range(R):
                        if valp[r] is valq[r]:
                            continue
                        er = self.new()
                        for u in range(n + 1):
                            self.cl(self.neg(valp[r][u]), self.neg(valq[r][u]), er)
                        lits.append(-er)
                    for a, b in ((ltp, ltq), (gtp, gtq)):
                        if a is b:
                            continue
                        fe = self.new()
                        self.cl(a, b, fe)
                        self.cl(self.neg(a), self.neg(b), fe)
                        lits.append(-fe)
                    e = self.new()
                    self.cl(e, *lits)
                    E[(i, p, q)] = E[(i, q, p)] = e
        T = len(idx)
        top = T  # default: full counter (keeps the CNF of the round-1 claims byte-identical)
        if steps is not None or subset is not None:
            top = 1
            while 2 * top <= T - 1:
                top *= 2  # largest threshold 2^m <= T - 1
        for i in range(k):
            for p in idx:
                xs = [E[(i, p, q)] for q in idx if q != p]
                # forcing counter: cnt[j] forced true if >= j of xs are true (j <= top)
                prev = [True] + [False] * top
                for x in xs:
                    cur = [True]
                    for j in range(1, top + 1):
                        a, b = prev[j], prev[j - 1]
                        if a is False and b is False:
                            cur.append(False)
                            continue
                        v = self.new()
                        self.cl(self.neg(a), v)
                        self.cl(self.neg(b), -x, v)
                        cur.append(v)
                    prev = cur
                m = 0
                while 2 ** m <= T - 1:
                    if m + 1 <= self.k:
                        self.cl(self.neg(prev[2 ** m]), self.Q[i][m + 1])
                    m += 1

    def _forced_pattern(self):
        """if maxmov == 0 and c + sum(blocks) == k, the op class of every step is implied: cmp, b_1 cmovs, cmp, ..."""
        pat = []
        for b in self.blocks:
            pat += ['cmp'] + ['cmov'] * b
        if self.maxmov != 0 or len(pat) != self.k:
            return
        cm = ['cmovl', 'cmovg', 'cmovle', 'cmovge']
        for i, p in enumerate(pat):
            if p == 'cmp':
                self.cl(self.op[i]['cmp'])
            else:
                self.cl(*self.is_op(i, cm))

    def _blocks(self):
        """exactly blocks[j-1] cmov steps have exactly j cmps before them (j = 1..c); none before the first cmp."""
        k, c = self.k, len(self.blocks)
        cm = ['cmovl', 'cmovg', 'cmovle', 'cmovge']
        G = [[True] + [False] * (c + 1)]  # G[i][j] <-> at least j cmps in steps < i (exact)
        for i in range(k):
            x = self.op[i]['cmp']
            row = [True]
            for j in range(1, c + 2):
                a, b = G[i][j], G[i][j - 1]
                if a is False and b is False:
                    row.append(False)
                    continue
                v = self.new()
                self.cl(self.neg(a), v)
                self.cl(-x, self.neg(b), v)
                self.cl(-v, a, x)
                self.cl(-v, a, b)
                row.append(v)
            G.append(row)
        for j in range(1, c + 1):
            zs = []
            for i in range(k):
                cmv = self.is_op(i, cm)
                z = self.new()  # z <-> (cmov at i) and exactly j cmps before i
                w = self.new()
                for l in cmv:
                    self.cl(-l, w)
                self.cl(-w, *cmv)
                self.cl(-z, w); self.cl(-z, G[i][j]); self.cl(-z, self.neg(G[i][j + 1]))
                self.cl(z, -w, self.neg(G[i][j]), G[i][j + 1])
                zs.append(z)
            b = self.blocks[j - 1]
            if b > 0:
                self.atleast(zs, b)
            if k - b > 0:
                self.atleast([-z for z in zs], k - b)

    def _rule_movfresh(self):
        """snap/free outputs, needs canon + nop: every mov writes a scratch register untouched before;
        a mov never reads an untouched scratch (that mov copies T onto T: a no-op)."""
        assert self.outmode in ('snap', 'free') and 'canon' in self.rules and self.nop
        n = self.n
        for i in range(self.k):
            mv = self.op[i]['mov']
            for r in range(n):
                self.cl(-mv, self.neg(self.d[i][r]))
            for j in range(self.R - n):
                self.cl(-mv, self.neg(self.d[i][n + j]), self.neg(self.touched[i][j]))
                self.cl(-mv, self.neg(self.s[i][n + j]), self.touched[i][j])

    def _rule_cmpord(self):
        """cmp A, B only with index(A) < index(B) (flip operands and swap l<->g, le<->ge in the readers)."""
        for i in range(self.k):
            c = self.op[i]['cmp']
            for x in range(self.R):
                for y in range(x + 1):
                    self.cl(-c, self.neg(self.d[i][x]), self.neg(self.s[i][y]))

    def _rule_dead(self):
        n, k, R = self.n, self.k, self.R
        wops = ['mov', 'cmovl', 'cmovg', 'cmovle', 'cmovge']
        # no mov/cmov r, r
        for i in range(k):
            for o in wops:
                if o in self.op[i]:
                    for r in range(R):
                        self.cl(-self.op[i][o], self.neg(self.d[i][r]), self.neg(self.s[i][r]))
        # liveness L[i][r] <-> r is read at step >= i before a mov overwrites it (exact definition)
        cmovs = ['cmovl', 'cmovg', 'cmovle', 'cmovge']
        L = [None] * (k + 1)
        if self.outmode == 'fixed':
            L[k] = [r < n for r in range(R)]
        elif self.outmode == 'free':
            L[k] = []
            for r in range(R):
                v = self.new()
                for j in range(n):
                    self.cl(-self.out[j][r], v)
                self.cl(-v, *[self.out[j][r] for j in range(n)])
                L[k].append(v)
        else:  # snap: snapshots are handled at the write itself
            L[k] = [False] * R
        nop = lambda i: self.op[i]['nop'] if self.nop else False
        for i in range(k - 1, -1, -1):
            L[i] = []
            for r in range(R):
                v = self.new()
                sr, dr = self.s[i][r], self.d[i][r]
                # a1 <-> s_i = r and op_i != nop ; a2 <-> d_i = r and op_i reads its dst (cmp/cmov)
                a1 = False
                if sr is not False:
                    a1 = self.new()
                    self.cl(-a1, sr); self.cl(-a1, self.neg(nop(i))); self.cl(-sr, nop(i), a1)
                a2 = False
                if dr is not False:
                    a2 = self.new()
                    self.cl(-a2, dr); self.cl(-a2, -self.op[i]['mov']); self.cl(-a2, self.neg(nop(i)))
                    self.cl(-dr, self.op[i]['mov'], nop(i), a2)
                # v <-> a1 or a2 or (L' and not (mov and d_i = r))
                self.cl(self.neg(a1), v)
                self.cl(self.neg(a2), v)
                self.cl(self.neg(L[i + 1][r]), self.op[i]['mov'], v)
                self.cl(self.neg(L[i + 1][r]), dr, v)
                self.cl(-v, a1, a2, L[i + 1][r])
                self.cl(-v, a1, a2, -self.op[i]['mov'], self.neg(dr))
                L[i].append(v)
        # every write must be live afterwards (or, in snap mode, be snapshotted)
        for i in range(k):
            snapped = self.snapped[i] if self.outmode == 'snap' else False
            for o in wops:
                if o in self.op[i]:
                    for r in range(R):
                        self.cl(-self.op[i][o], self.neg(self.d[i][r]), L[i + 1][r], snapped)
        self.L = L

    def _rule_flags(self):
        k = self.k
        cmovs = ['cmovl', 'cmovg', 'cmovle', 'cmovge']
        FL = [None] * (k + 1)  # FL[i] <-> flags are read by a cmov at step >= i before the next cmp
        FL[k] = False
        for i in range(k - 1, -1, -1):
            v = self.new()
            cm = self.is_op(i, cmovs)
            for o in cm:
                self.cl(-o, v)
            self.cl(self.neg(FL[i + 1]), self.op[i]['cmp'], v)
            self.cl(-v, *cm, FL[i + 1])
            self.cl(-v, *cm, -self.op[i]['cmp'])
            FL[i] = v
        for i in range(k):
            self.cl(-self.op[i]['cmp'], FL[i + 1])
        # no cmov before the first cmp (seen[i]: some cmp at step < i)
        seen = [False]
        for i in range(k):
            v = self.new()
            c = self.op[i]['cmp']
            self.cl(self.neg(seen[i]), v)
            self.cl(-c, v)
            self.cl(-v, seen[i], c)
            seen.append(v)
            for o in cmovs:
                if o in self.op[i]:
                    self.cl(-self.op[i][o], seen[i])
        self.FL = FL

    def _rule_comm(self):
        n, k, R = self.n, self.k, self.R
        wops = ['mov', 'cmovl', 'cmovg', 'cmovle', 'cmovge']
        cmovs = ['cmovl', 'cmovg', 'cmovle', 'cmovge']
        rops = [o for o in self.ops if o != 'nop']
        canon = bool(self.rules & {'canon', 'pcanon'})

        def same(x, y):
            """only-if literal: x (one-hot row) and y (one-hot row) select the same register."""
            e = self.new()
            for r in range(R):
                if x[r] is False:
                    continue
                self.cl(-e, self.neg(x[r]), y[r])
            return e

        def force_same(e, x, y):  # completeness: equal selection forces e
            for r in range(R):
                self.cl(self.neg(x[r]), self.neg(y[r]), e)

        for i in range(k - 1):
            A, B = i, i + 1
            dep = []  # literals; one true => dependent; each true only if really dependent
            # flag dependences
            for (X, Y) in [(A, B), (B, A)]:
                for oc in self.is_op(X, ['cmp']):
                    for oy in self.is_op(Y, ['cmp'] + cmovs):
                        g = self.new()
                        self.cl(-g, oc)
                        self.cl(-g, oy)
                        dep.append(g)
            # register dependences: X writes d_X and Y touches d_X (as d or s)
            for (X, Y) in [(A, B), (B, A)]:
                for (yrow) in [self.d[Y], self.s[Y]]:
                    e = same(self.d[X], yrow)
                    g = self.new()
                    self.cl(-g, e)
                    self.cl(-g, *self.is_op(X, wops))
                    # Y must be a real op (nop is never paired: nops are at the end anyway)
                    dep.append(g)
                # X writes d_X and Y reads... covered: any non-nop op of Y touches d_Y and s_Y
            both = False
            if canon:
                both = self.new()
                self.cl(-both, self.ft[A])
                self.cl(-both, self.ft[B])
            ex = dep + ([both] if canon else [])
            if self.nop:
                ex = ex + [self.op[B]['nop']]
            # lex order (op, d, s) for A <= B
            oidx = {o: x for x, o in enumerate(self.ops)}
            for a in rops:
                for b in rops:
                    if oidx[a] > oidx[b]:
                        self.cl(-self.op[A][a], -self.op[B][b], *ex)
            eop = self.new()
            for a in rops:
                self.cl(-self.op[A][a], -self.op[B][a], eop)
            for x in range(R):
                for y in range(x):
                    if self.d[A][x] is False or self.d[B][y] is False:
                        continue
                    self.cl(-eop, -self.d[A][x], -self.d[B][y], *ex)
            ed = self.new()
            force_same(ed, self.d[A], self.d[B])
            for x in range(R):
                for y in range(x):
                    if self.s[A][x] is False or self.s[B][y] is False:
                        continue
                    self.cl(-eop, -ed, -self.s[A][x], -self.s[B][y], *ex)
            # eop / ed only need the "forced true" direction; spurious truth only adds an escape-free
            # clause when ops really are equal, so force them false when ops differ:
            for a in rops:
                for b in rops:
                    if a != b:
                        self.cl(-eop, -self.op[A][a], -self.op[B][b])
            for x in range(R):
                for y in range(R):
                    if x != y and self.d[A][x] is not False and self.d[B][y] is not False:
                        self.cl(-ed, -self.d[A][x], -self.d[B][y])

    # ---- order types ---------------------------------------------------------------------------
    def add_type(self, rk):
        """Add constraints for order type rk (rank tuple). Returns index of first new clause."""
        start = len(self.clauses)
        n, k, R = self.n, self.k, self.R
        T = n
        rank = list(rk) + [10 ** 6]
        V = n + 1
        # initial values
        val = []
        for r in range(R):
            u0 = r if r < n else T
            val.append([u == u0 for u in range(V)])
        lt, gt = False, False
        nvs = []
        trace = []  # trace[i] = (val rows, lt, gt) before step i
        for i in range(k):
            trace.append((val, lt, gt))
            # sv, dv
            sv = [self.new() for u in range(V)]
            dv = [self.new() for u in range(V)]
            for row, x in [(self.s[i], sv), (self.d[i], dv)]:
                for r in range(R):
                    if row[r] is False:
                        continue
                    for u in range(V):
                        self.cl(-row[r], self.neg(val[r][u]), x[u])
                        self.cl(-row[r], val[r][u], -x[u])
            last = (i == k - 1)
            # write condition
            wr = self.new()
            ops = self.op[i]
            self.cl(-ops['mov'], wr)
            self.cl(-ops['cmp'], -wr)
            if 'nop' in ops:
                self.cl(-ops['nop'], -wr)
            for o, flag, pos in [('cmovl', lt, True), ('cmovg', gt, True), ('cmovle', gt, False), ('cmovge', lt, False)]:
                if o not in ops:
                    continue
                on = flag if pos else self.neg(flag)
                self.cl(-ops[o], self.neg(on), wr)
                self.cl(-ops[o], on, -wr)
            nv = [self.new() for u in range(V)]
            nvs.append(nv)
            for u in range(V):
                self.cl(-wr, -sv[u], nv[u])
                self.cl(-wr, sv[u], -nv[u])
                self.cl(wr, -dv[u], nv[u])
                self.cl(wr, dv[u], -nv[u])
            # next values
            nval = []
            for r in range(R):
                dr = self.d[i][r]
                if dr is False:
                    nval.append(val[r])
                    continue
                row = [self.new() for u in range(V)]
                for u in range(V):
                    self.cl(-dr, -nv[u], row[u])
                    self.cl(-dr, nv[u], -row[u])
                    self.cl(dr, self.neg(val[r][u]), row[u])
                    self.cl(dr, val[r][u], -row[u])
                nval.append(row)
            # flags
            if not last:
                nlt, ngt = self.new(), self.new()
                c = ops['cmp']
                for u in range(V):
                    for w in range(V):
                        self.cl(-c, -dv[u], -sv[w], nlt if rank[u] < rank[w] else -nlt)
                        self.cl(-c, -dv[u], -sv[w], ngt if rank[u] > rank[w] else -ngt)
                self.cl(c, self.neg(lt), nlt)
                self.cl(c, lt, -nlt)
                self.cl(c, self.neg(gt), ngt)
                self.cl(c, gt, -ngt)
                lt, gt = nlt, ngt
            val = nval
        # output
        srt = sorted(rk)
        if self.outmode == 'fixed':
            for j in range(n):
                for u in range(V):
                    if u == T or rank[u] != srt[j]:
                        self.cl(self.neg(val[j][u]))
        elif self.outmode == 'free':
            for j in range(n):
                good = [u for u in range(n) if rank[u] == srt[j]]
                for r in range(R):
                    self.cl(-self.out[j][r], *[val[r][u] for u in good])
        else:
            for j in range(n):
                good = [u for u in range(n) if rank[u] == srt[j]]
                for r in range(n):
                    if rank[r] != srt[j]:
                        self.cl(-self.osnap[j][r])
                for i in range(k):
                    self.cl(-self.osnap[j][n + i], *[nvs[i][u] for u in good])
        self.types.append(tuple(rk))
        self.traces.append((trace, nvs))
        return start

    # ---- decoding / output ---------------------------------------------------------------------
    def decode(self, model):
        m = set(l for l in model if l > 0)
        prog = []
        for i in range(self.k):
            o = [o for o in self.ops if self.op[i][o] in m]
            d = [r for r in range(self.R) if self.d[i][r] is not False and self.d[i][r] in m]
            s = [r for r in range(self.R) if self.s[i][r] is not False and self.s[i][r] in m]
            assert len(o) == 1 and len(d) == 1 and len(s) == 1, (i, o, d, s)
            prog.append((o[0], d[0], s[0]))
        outmap = None
        if self.outmode == 'free':
            outmap = [[r for r in range(self.R) if self.out[j][r] in m][0] for j in range(self.n)]
        if self.outmode == 'snap':  # list of (time, register): time 0 = start, time i+1 = after step i
            outmap = []
            for j in range(self.n):
                x = [x for x in range(self.n + self.k) if self.osnap[j][x] in m][0]
                outmap.append((0, x) if x < self.n else (x - self.n + 1, prog[x - self.n][1]))
        return prog, outmap

    def dimacs(self, path, comment=''):
        with open(path, 'w') as f:
            for line in comment.splitlines():
                f.write('c %s\n' % line)
            f.write('p cnf %d %d\n' % (self.nvars, len(self.clauses)))
            for c in self.clauses:
                f.write(' '.join(map(str, c)) + ' 0\n')


def main():
    import argparse, ast
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('-n', type=int, required=True)
    ap.add_argument('-k', type=int, required=True)
    ap.add_argument('-R', type=int, default=None)
    ap.add_argument('--iset', default='I0', choices=['I0', 'I1'])
    ap.add_argument('--outmode', default='fixed', choices=['fixed', 'free', 'snap'])
    ap.add_argument('--rules', default='', help='comma list of ' + ','.join(ALL_RULES) + ' or "all"')
    ap.add_argument('--nop', action='store_true', help='allow nop (<= k)')
    ap.add_argument('--types', default='all', help='"all" (weak orders), "total", or python list of rank tuples')
    ap.add_argument('-o', required=True)
    a = ap.parse_args()
    import sim
    rules = [r for r in ALL_RULES if a.outmode != 'fixed' or r != 'pcanon'] if a.rules == 'all' else [r for r in a.rules.split(',') if r]
    e = Enc(a.n, a.k, a.R, a.iset, a.outmode, rules, a.nop)
    types = sim.weak_orders(a.n) if a.types == 'all' else sim.total_orders(a.n) if a.types == 'total' \
        else ast.literal_eval(a.types)
    for t in types:
        e.add_type(t)
    e.dimacs(a.o, 'n=%d k=%d R=%d iset=%s outmode=%s rules=%s nop=%s types=%s' %
             (a.n, a.k, e.R, a.iset, a.outmode, ','.join(rules), a.nop, types))
    print(e.nvars, len(e.clauses))


if __name__ == '__main__':
    main()
