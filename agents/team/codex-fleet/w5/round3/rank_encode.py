"""Independent three-bit rank transition encoding for local SAT repair.

Program selectors and output selectors come from Enc. This module replaces
the transition relation. Values are concrete ranks 0..4; scratch is 7.
Initial flags are equal. This remains a relaxed model, not a strict checker.
"""
from encode import Enc


class RankEnc(Enc):
    def and_(self, *xs):
        ys = []
        for x in xs:
            if x is False:
                return False
            if x is not True and x not in ys:
                if self.neg(x) in ys:
                    return False
                ys.append(x)
        if not ys:
            return True
        if len(ys) == 1:
            return ys[0]
        z = self.new()
        for x in ys:
            self.cl(-z, x)
        self.cl(z, *[self.neg(x) for x in ys])
        return z

    def or_(self, *xs):
        return self.neg(self.and_(*[self.neg(x) for x in xs]))

    def ite_(self, c, a, b):
        if c is True:
            return a
        if c is False:
            return b
        if a == b and type(a) is type(b):
            return a
        if a is True and b is False:
            return c
        if a is False and b is True:
            return self.neg(c)
        z = self.new()
        self.cl(self.neg(c), self.neg(a), z)
        self.cl(self.neg(c), a, -z)
        self.cl(c, self.neg(b), z)
        self.cl(c, b, -z)
        return z

    def select_(self, selectors, values):
        out = [self.new() for _ in range(3)]
        for r, selector in enumerate(selectors):
            for bit, z in enumerate(out):
                value = values[r][bit]
                self.cl(-selector, self.neg(value), z)
                self.cl(-selector, value, -z)
        return out

    def less_(self, a, b):
        # Process low bits first. A larger bit overrides the lower-bit result.
        less = False
        for bit in range(3):
            x, y = a[bit], b[bit]
            equal = self.ite_(x, y, self.neg(y))
            less = self.or_(self.and_(self.neg(x), y), self.and_(equal, less))
        return less

    def add_type(self, rk):
        start = len(self.clauses)
        rs = [[bool(((rk[r] if r < 5 else 7) >> bit) & 1)
               for bit in range(3)] for r in range(self.R)]
        lt = gt = False
        writes = []
        for i in range(self.k):
            op = self.op[i]
            a, b = self.select_(self.d[i], rs), self.select_(self.s[i], rs)
            wr = self.or_(op['mov'], self.and_(op['cmovl'], lt),
                          self.and_(op['cmovle'], self.neg(gt)),
                          self.and_(op['cmovg'], gt),
                          self.and_(op['cmovge'], self.neg(lt)))
            writes.append([self.ite_(wr, b[bit], a[bit]) for bit in range(3)])
            nrs = []
            for r in range(self.R):
                write_here = self.and_(wr, self.d[i][r])
                nrs.append([self.ite_(write_here, b[bit], rs[r][bit])
                            for bit in range(3)])
            if i+1 < self.k:
                lt, gt = (self.ite_(op['cmp'], self.less_(a, b), lt),
                          self.ite_(op['cmp'], self.less_(b, a), gt))
            rs = nrs
        if getattr(self, 'check_outputs', True):
            goals = sorted(rk)
            for j in range(5):
                for r in range(5):
                    if rk[r] != goals[j]:
                        self.cl(-self.osnap[j][r])
                for i, bits in enumerate(writes):
                    for bit, value in enumerate(bits):
                        self.cl(-self.osnap[j][5+i],
                                value if ((goals[j] >> bit) & 1) else self.neg(value))
        self.types.append(tuple(rk))
        self.traces.append(writes)
        return start
