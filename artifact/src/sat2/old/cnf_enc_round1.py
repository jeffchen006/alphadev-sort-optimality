"""sat2 encoding A: CNF with LOG (binary) encoding.

- Instruction t: op code bits, dst bits, src bits (binary numbers, not one-hot).
- Per order type e: every register holds a w-bit binary VALUE (rank of the input it holds, T = n);
  operand reads are binary multiplexer trees driven by the dst/src bits; flags come from a binary
  comparator circuit. Constant folding keeps the initial state small.
"""
from common import ISETS

ALL_RULES = {"scr", "tread", "comm", "noop", "precmov", "deadcmp", "deadw", "live", "llS", "llP", "llPall", "snapT"}


def nbits(x):
    """bits needed for numbers 0..x-1 (at least 1)"""
    b = 1
    while (1 << b) < x:
        b += 1
    return b


class Circuit:
    def __init__(self):
        self.nv = 1
        self.clauses = [[1]]  # var 1 = TRUE
        self.T, self.F = 1, -1
        self.sink = None  # optional callable(clause) for incremental solvers

    def new(self):
        self.nv += 1
        return self.nv

    def add(self, cl):
        self.clauses.append(cl)
        if self.sink is not None:
            self.sink(cl)

    def and_(self, lits):
        s = set()
        for l in lits:
            if l == self.F:
                return self.F
            if l == self.T:
                continue
            if -l in s:
                return self.F
            s.add(l)
        if not s:
            return self.T
        if len(s) == 1:
            return next(iter(s))
        g = self.new()
        for l in s:
            self.add([-g, l])
        self.add([g] + [-l for l in s])
        return g

    def or_(self, lits):
        return -self.and_([-l for l in lits])

    def ite(self, c, a, b):
        if c == self.T or a == b:
            return a
        if c == self.F:
            return b
        if a == self.T and b == self.F:
            return c
        if a == self.F and b == self.T:
            return -c
        if a == self.T:
            return self.or_([c, b])
        if a == self.F:
            return self.and_([-c, b])
        if b == self.T:
            return self.or_([-c, a])
        if b == self.F:
            return self.and_([c, a])
        g = self.new()
        self.add([-c, -a, g]); self.add([-c, a, -g])
        self.add([c, -b, g]); self.add([c, b, -g])
        self.add([-a, -b, g]); self.add([a, b, -g])
        return g

    def xnor(self, a, b):
        return self.ite(a, b, -b)

    def eq_const(self, bits, val):
        return self.and_([bits[i] if (val >> i) & 1 else -bits[i] for i in range(len(bits))])

    def const(self, val, w):
        return [self.T if (val >> i) & 1 else self.F for i in range(w)]

    def mux(self, sel, words):
        """words[i] selected by binary number sel (LSB first)."""
        cur = list(words)
        for lvl in range(len(sel)):
            if len(cur) % 2:
                cur.append(cur[-1])
            cur = [[self.ite(sel[lvl], hi[i], lo[i]) for i in range(len(lo))]
                   for lo, hi in zip(cur[0::2], cur[1::2])]
        assert len(cur) == 1
        return cur[0]

    def less(self, a, b):
        """unsigned a < b, bits LSB first"""
        lt = self.F
        for i in range(len(a)):
            lt = self.or_([self.and_([-a[i], b[i]]), self.and_([self.xnor(a[i], b[i]), lt])])
        return lt

    def at_least(self, lits, m):
        """literal for: at least m of lits are true (sequential counter)"""
        cnt = [self.T] + [self.F] * m  # cnt[j]: at least j so far
        for x in lits:
            cnt = [self.T] + [self.or_([cnt[j], self.and_([cnt[j - 1], x])]) for j in range(1, m + 1)]
        return cnt[m]

    def lt_const(self, bits, c):
        """bits < c (constant), for range constraints"""
        if c >= (1 << len(bits)):
            return self.T
        lt = self.F
        for i in range(len(bits)):
            if (c >> i) & 1:
                lt = self.or_([-bits[i], lt])  # bit 0 < 1, or equal (bit=1) and lower part less
            else:
                lt = self.and_([-bits[i], lt])
        return lt


class CNFEncoding:
    def __init__(self, n, k, R, iset="I0", outmode="fixed", no_noop=False, scratch_sym=True, sink=None,
                 rules=(), min_cmp=0, min_cmov=0):
        self.n, self.k, self.R = n, k, R
        self.ops = ISETS[iset]
        self.c = c = Circuit()
        c.sink = sink
        self.w = nbits(n + 1)  # values 0..n-1 and T = n
        self.b = nbits(R)
        self.ob = nbits(len(self.ops))
        assert outmode in ("fixed", "free", "snap", "snapw")
        self.outmode = outmode
        self.op, self.dst, self.src = [], [], []
        self.isop, self.isdst = [], []
        for t in range(k):
            op = [c.new() for _ in range(self.ob)]
            d = [c.new() for _ in range(self.b)]
            s = [c.new() for _ in range(self.b)]
            c.add([c.lt_const(op, len(self.ops))])
            c.add([c.lt_const(d, R)])
            c.add([c.lt_const(s, R)])
            self.op.append(op); self.dst.append(d); self.src.append(s)
            self.isop.append({name: c.eq_const(op, i) for i, name in enumerate(self.ops)})
            self.isdst.append([c.eq_const(d, r) for r in range(R)])
            if no_noop:
                same = c.and_([c.xnor(d[i], s[i]) for i in range(self.b)])
                c.add([self.isop[t]["cmp"], -same])
        if scratch_sym and "llS" not in set(rules):
            rules = set(rules) | {"scr"}
        self.rules = rules = set(rules)
        assert rules <= ALL_RULES, rules - ALL_RULES
        if outmode != "fixed":
            self.outsel = [[c.new() for _ in range(self.b)] for _ in range(n)]
            for o in self.outsel:
                c.add([c.lt_const(o, R)])
        if outmode in ("snap", "snapw"):  # output j = register outsel[j] after outtime[j] steps (judge model=out)
            tb = nbits(k + 1)
            self.outtime = [[c.new() for _ in range(tb)] for _ in range(n)]
            for o in self.outtime:
                c.add([c.lt_const(o, k + 1)])
        if outmode == "snapw":
            # R5 built in: a snapshot with outtime = t < k reads the register that step t overwrites (its dst),
            # so instruction t must write; outsel is then only used for outtime = k (final register).
            for j in range(n):
                for t in range(k):
                    c.add([-c.eq_const(self.outtime[j], t), -self.isop[t]["cmp"]])
        self._rules(rules)
        # cardinality cuts (bounds C1/C2, implied constraints; see RULES.md)
        if min_cmp:
            c.add([c.at_least([self.isop[t]["cmp"] for t in range(k)], min_cmp)])
        if min_cmov:
            c.add([c.at_least([-c.or_([self.isop[t]["cmp"], self.isop[t]["mov"]]) for t in range(k)], min_cmov)])
        self.types = []
        self.flaghist = {}

    def _rules(self, rules):
        """Symmetry / minimality rules. Soundness argument: RULES.md (theory must review)."""
        c, n, k, R = self.c, self.n, self.k, self.R
        S = R - n
        last = R - 1
        iscmp = [self.isop[t]["cmp"] for t in range(k)]
        ismov = [self.isop[t]["mov"] for t in range(k)]
        iscmov = [-c.or_([iscmp[t], ismov[t]]) for t in range(k)]  # any conditional move
        wr = [-iscmp[t] for t in range(k)]  # writes a register (mov or cmov*)
        issrc = [[c.eq_const(self.src[t], r) for r in range(R)] for t in range(k)]
        # wb[t][j]: scratch S_j written at some step < t
        wb = [[c.F] * S]
        for t in range(k):
            wb.append([c.or_([wb[t][j], c.and_([self.isdst[t][n + j], wr[t]])]) for j in range(S)])
        if "scr" in rules:  # R1: first writes of scratch registers in index order
            for t in range(k):
                for j in range(S - 1):
                    c.add([-self.isdst[t][n + j + 1], -wr[t], wb[t][j]])
        if "tread" in rules:  # R2: a read of a not-yet-written scratch uses S_last; S_last is never written
            assert S >= 1
            for t in range(k):
                c.add([-self.isdst[t][last], -wr[t]])
                for j in range(S - 1):
                    c.add([-issrc[t][n + j], wb[t][j]])
                    c.add([-self.isdst[t][n + j], -iscmp[t], wb[t][j]])
        if "comm" in rules:  # R3: adjacent commuting instructions in non-decreasing code order
            def eqb(a, b):
                return c.and_([c.xnor(x, y) for x, y in zip(a, b)])
            code = [self.src[t] + self.dst[t] + self.op[t] for t in range(k)]
            for t in range(k - 1):
                u = t + 1
                dd = eqb(self.dst[t], self.dst[u])
                du_st = eqb(self.dst[u], self.src[t])
                dt_su = eqb(self.dst[t], self.src[u])
                comm = c.and_([-dd, c.or_([
                    c.and_([iscmp[t], ismov[u], -du_st]),
                    c.and_([ismov[t], iscmp[u], -dt_su]),
                    c.and_([wr[t], wr[u], -du_st, -dt_su])])])
                c.add([-comm, -c.less(code[u], code[t])])
        if {"llS", "llP", "llPall"} & rules:
            # Framework B (RULES.md): lex-least program in the orbit under swaps + renamings.
            # Q <=lex pi(Q) for adjacent transpositions pi; not combinable with scr/tread.
            # llS is not combinable with scr/tread; llP is (P renaming commutes with the scr/tread normal form)
            assert not ("llS" in rules and {"scr", "tread"} & rules), "llS uses a different canonical form"
            perms = []  # register maps {x: pi(x)}
            if "llS" in rules:
                perms += [{n + j: n + j + 1, n + j + 1: n + j} for j in range(S - 1)]
            if "llP" in rules or "llPall" in rules:
                assert self.outmode != "fixed", "P symmetry needs free or snap outputs"
                if "llPall" in rules:
                    import itertools
                    perms += [{i: p[i] for i in range(n) if p[i] != i}
                              for p in itertools.permutations(range(n)) if list(p) != list(range(n))]
                else:
                    perms += [{i: i + 1, i + 1: i} for i in range(n - 1)]
            for pm in perms:
                def img(f):
                    out = list(f)
                    for x, y in pm.items():
                        isx = c.eq_const(f, x)
                        by = c.const(y, self.b)
                        out = [c.ite(isx, by[i], out[i]) for i in range(self.b)]
                    return out
                eqpre = c.T
                for t in range(k):
                    a = self.src[t] + self.dst[t] + self.op[t]
                    pa = img(self.src[t]) + img(self.dst[t]) + self.op[t]
                    c.add([-eqpre, -c.less(pa, a)])
                    eqpre = c.and_([eqpre] + [c.xnor(u, v) for u, v in zip(a, pa)])
                    if eqpre == c.F:
                        break
        if "noop" in rules:  # M1: no mov/cmov D, D
            for t in range(k):
                c.add([-wr[t], -c.and_([c.xnor(x, y) for x, y in zip(self.dst[t], self.src[t])])])
        if "precmov" in rules:  # M2/R4: no conditional move before the first cmp
            seen = c.F
            for t in range(k):
                c.add([-iscmov[t], seen])
                seen = c.or_([seen, iscmp[t]])
        if "deadcmp" in rules:  # M3: flags of every cmp are read by a cmov before the next cmp / the end
            pend = c.F
            for t in range(k):
                c.add([-iscmp[t], -pend])
                pend = c.or_([iscmp[t], c.and_([pend, -iscmov[t]])])
            c.add([-pend])
        if self.outmode == "snap":
            # snaprd[t][r]: some output snapshot reads r after t steps
            self.snaprd = [[c.or_([c.and_([c.eq_const(self.outtime[j], t), c.eq_const(self.outsel[j], r)])
                                   for j in range(n)]) for r in range(R)] for t in range(k + 1)]
        if self.outmode == "snapw":
            self.snaprd = [[c.or_([c.and_([c.eq_const(self.outtime[j], t),
                                           self.isdst[t][r] if t < k else c.eq_const(self.outsel[j], r)])
                                   for j in range(n)]) for r in range(R)] for t in range(k + 1)]
        if "snapT" in rules:  # R5: a snapshot is at the end or just before a write to its register
            assert self.outmode == "snap"
            for j in range(n):
                for t in range(k):
                    at = c.eq_const(self.outtime[j], t)
                    c.add([-at, wr[t]])
                    for i in range(self.b):
                        c.add([-at, c.xnor(self.dst[t][i], self.outsel[j][i])])  # dst_t == outsel_j
        if "deadw" in rules:  # M4: no write is overwritten by a mov before a read; unread writes at the end
            pw = [c.F] * R
            for t in range(k):
                if self.outmode in ("snap", "snapw"):
                    pw = [c.and_([pw[r], -self.snaprd[t][r]]) for r in range(R)]
                for r in range(R):
                    rd = c.or_([issrc[t][r], c.and_([self.isdst[t][r], -ismov[t]])])  # cmp/cmov read D
                    c.add([-ismov[t], -self.isdst[t][r], -pw[r], issrc[t][r]])
                    pw[r] = c.or_([c.and_([self.isdst[t][r], wr[t]]), c.and_([pw[r], -rd])])
            if self.outmode == "fixed":
                for r in range(n, R):
                    c.add([-pw[r]])
            elif self.outmode in ("snap", "snapw"):  # snapshots are the only outputs
                for r in range(R):
                    c.add([-pw[r], self.snaprd[k][r]])

    def add_type(self, e):
        c, n, w = self.c, self.n, self.w
        regs = [c.const(e[i], w) for i in range(n)] + [c.const(n, w) for _ in range(self.R - n)]
        lt, gt = c.F, c.F
        hist = [regs]
        As = []
        flags = [(lt, gt)]
        for t in range(self.k):
            A = c.mux(self.dst[t], regs)
            B = c.mux(self.src[t], regs)
            As.append(A)
            iso = self.isop[t]
            clt, cgt = c.less(A, B), c.less(B, A)
            terms = [iso["mov"], c.and_([iso["cmovl"], lt]), c.and_([iso["cmovg"], gt])]
            if "cmovle" in iso:
                terms.append(c.and_([iso["cmovle"], -gt]))
                terms.append(c.and_([iso["cmovge"], -lt]))
            we = c.or_(terms)
            regs = [[c.ite(c.and_([we, self.isdst[t][r]]), B[i], regs[r][i]) for i in range(w)]
                    for r in range(self.R)]
            lt = c.ite(iso["cmp"], clt, lt)
            gt = c.ite(iso["cmp"], cgt, gt)
            hist.append(regs)
            flags.append((lt, gt))
        self.flaghist[tuple(e)] = flags
        want = sorted(e)
        if "live" in self.rules:
            # implied: a value is never re-created, so every value an output still needs is in some register
            for t in range(1, self.k):
                for v in sorted(set(e)):
                    pres = c.or_([c.eq_const(hist[t][r], v) for r in range(self.R)])
                    if self.outmode not in ("snap", "snapw"):
                        c.add([pres])
                    else:
                        for j in range(n):
                            if want[j] == v:  # needed while outtime[j] >= t
                                c.add([c.lt_const(self.outtime[j], t), pres])
        for j in range(n):
            if self.outmode == "fixed":
                val = regs[j]
            elif self.outmode == "free":
                val = c.mux(self.outsel[j], regs)
            elif self.outmode == "snap":
                val = c.mux(self.outtime[j], [c.mux(self.outsel[j], h) for h in hist])
            else:
                val = c.mux(self.outtime[j], As + [c.mux(self.outsel[j], regs)])
            for i in range(w):
                c.add([val[i] if (want[j] >> i) & 1 else -val[i]])
        self.types.append(e)

    def add_hcmp(self, perms):
        """Per-step L7 (implied, theory L7 argument): permutations with equal flags at every step <= t form a class;
        a class of size s needs >= ceil(log2 s) cmp at steps >= t. perms: list of permutation types already added."""
        c, k = self.c, self.k
        iscmp = [self.isop[t]["cmp"] for t in range(k)]
        # rem[t][r]: at least r cmp among steps t..k-1
        maxr = (len(perms) - 1).bit_length()
        rem = []
        for t in range(k + 1):
            rem.append([c.T] + [c.at_least(iscmp[t:], r) if r <= k - t else c.F for r in range(1, maxr + 1)])
        P = [tuple(e) for e in perms]
        same = {}
        for a in range(len(P)):
            for b in range(a + 1, len(P)):
                fa, fb = self.flaghist[P[a]], self.flaghist[P[b]]
                cur, seq = c.T, []
                for t in range(k + 1):
                    cur = c.and_([cur, c.xnor(fa[t][0], fb[t][0]), c.xnor(fa[t][1], fb[t][1])])
                    seq.append(cur)
                same[a, b] = same[b, a] = seq
        for a in range(len(P)):
            for t in range(k + 1):
                others = [same[a, b][t] for b in range(len(P)) if b != a]
                cnt = [c.T] + [c.F] * (1 << (maxr - 1))
                for x in others:  # cnt[j]: at least j others in my class
                    cnt = [c.T] + [c.or_([cnt[j], c.and_([cnt[j - 1], x])]) for j in range(1, len(cnt))]
                for r in range(maxr):  # >= 2^r others => class size > 2^r => >= r+1 cmp from t on
                    if (1 << r) < len(cnt):
                        c.add([-cnt[1 << r], rem[t][r + 1]])

    def decode(self, model):
        pos = set(l for l in model if l > 0)
        num = lambda bits: sum(1 << i for i, v in enumerate(bits) if v in pos)
        prog = [(self.ops[num(self.op[t])], num(self.dst[t]), num(self.src[t])) for t in range(self.k)]
        if self.outmode == "fixed":
            outs = list(range(self.n))
        elif self.outmode == "free":
            outs = [num(o) for o in self.outsel]
        elif self.outmode == "snap":
            outs = [(num(tt), num(o)) for tt, o in zip(self.outtime, self.outsel)]
        else:
            outs = []
            for tt, o in zip(self.outtime, self.outsel):
                t = num(tt)
                outs.append((t, prog[t][1]) if t < self.k else (t, num(o)))
        return prog, outs
