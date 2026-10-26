"""sat2 encoding B: SMT (z3, QF_BV).

Instruction fields are bit-vectors; each register holds a bit-vector VALUE per order type
(rank of the held input, T = n); operand reads are if-then-else chains; flags use bvult.
"""
import z3
from common import ISETS
from cnf_enc import nbits


class SMTEncoding:
    def __init__(self, n, k, R, iset="I0", outmode="fixed", no_noop=False, scratch_sym=True, sink=None):
        self.n, self.k, self.R = n, k, R
        self.ops = ISETS[iset]
        self.w = nbits(n + 1)
        self.b = nbits(R)
        self.ob = nbits(len(self.ops))
        self.outmode = outmode
        self.s = z3.SolverFor("QF_BV")
        self.op = [z3.BitVec(f"op{t}", self.ob) for t in range(k)]
        self.dst = [z3.BitVec(f"d{t}", self.b) for t in range(k)]
        self.src = [z3.BitVec(f"s{t}", self.b) for t in range(k)]
        A = self.s.add
        for t in range(k):
            A(self.ult(self.op[t], len(self.ops)), self.ult(self.dst[t], R), self.ult(self.src[t], R))
            if no_noop:
                A(z3.Or(self.op[t] == self.code("cmp"), self.dst[t] != self.src[t]))
        if scratch_sym:
            for t in range(k):
                for j in range(R - n - 1):
                    wr_next = z3.And(self.dst[t] == n + j + 1, self.op[t] != self.code("cmp"))
                    before = [z3.And(self.dst[u] == n + j, self.op[u] != self.code("cmp")) for u in range(t)]
                    A(z3.Implies(wr_next, z3.Or(before) if before else False))
        if outmode != "fixed":
            self.outsel = [z3.BitVec(f"out{j}", self.b) for j in range(n)]
            for o in self.outsel:
                A(self.ult(o, R))
        if outmode == "snap":
            self.outtime = [z3.BitVec(f"outt{j}", nbits(k + 1)) for j in range(n)]
            for o in self.outtime:
                A(self.ult(o, k + 1))
        self.types = []

    def ult(self, x, c):
        # c may equal 2^width; z3 would wrap the constant to 0
        return z3.BoolVal(True) if c >= (1 << x.size()) else z3.ULT(x, c)

    def code(self, name):
        return z3.BitVecVal(self.ops.index(name), self.ob)

    def read(self, regs, sel):
        v = regs[-1]
        for r in range(len(regs) - 2, -1, -1):
            v = z3.If(sel == r, regs[r], v)
        return v

    def add_type(self, e):
        n, w, R = self.n, self.w, self.R
        tag = "".join(map(str, e))
        regs = [z3.BitVecVal(e[i], w) for i in range(n)] + [z3.BitVecVal(n, w)] * (R - n)
        lt, gt = z3.BoolVal(False), z3.BoolVal(False)
        hist = [regs]
        for t in range(self.k):
            op, d, s = self.op[t], self.dst[t], self.src[t]
            a = self.read(regs, d)
            b = self.read(regs, s)
            terms = [op == self.code("mov"), z3.And(op == self.code("cmovl"), lt),
                     z3.And(op == self.code("cmovg"), gt)]
            if "cmovle" in self.ops:
                terms += [z3.And(op == self.code("cmovle"), z3.Not(gt)),
                          z3.And(op == self.code("cmovge"), z3.Not(lt))]
            we = z3.Bool(f"we_{tag}_{t}")
            self.s.add(we == z3.Or(terms))
            nregs = []
            for r in range(R):
                v = z3.BitVec(f"v_{tag}_{t}_{r}", w)
                self.s.add(v == z3.If(z3.And(we, d == r), b, regs[r]))
                nregs.append(v)
            nlt, ngt = z3.Bool(f"lt_{tag}_{t}"), z3.Bool(f"gt_{tag}_{t}")
            iscmp = op == self.code("cmp")
            self.s.add(nlt == z3.If(iscmp, z3.ULT(a, b), lt), ngt == z3.If(iscmp, z3.UGT(a, b), gt))
            regs, lt, gt = nregs, nlt, ngt
            hist.append(regs)
        want = sorted(e)
        for j in range(n):
            if self.outmode == "fixed":
                val = regs[j]
            elif self.outmode == "free":
                val = self.read(regs, self.outsel[j])
            else:
                val = self.read([self.read(h, self.outsel[j]) for h in hist], self.outtime[j])
            self.s.add(val == want[j])
        self.types.append(e)

    def solve(self):
        r = self.s.check()
        if r == z3.unsat:
            return None
        assert r == z3.sat, r
        m = self.s.model()
        num = lambda x: m.eval(x, model_completion=True).as_long()
        prog = [(self.ops[num(self.op[t])], num(self.dst[t]), num(self.src[t])) for t in range(self.k)]
        if self.outmode == "fixed":
            outs = list(range(self.n))
        elif self.outmode == "free":
            outs = [num(o) for o in self.outsel]
        else:
            outs = [(num(tt), num(o)) for tt, o in zip(self.outtime, self.outsel)]
        return prog, outs
