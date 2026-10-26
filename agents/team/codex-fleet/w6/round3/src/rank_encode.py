"""Rank-value SAT encoding with constant propagation for fixed instructions.

Scratch starts above all inputs and flags start equal. This is a relaxed
initial state. The strict judge remains necessary for a solver candidate.
"""
from encode import Enc


class RankEnc(Enc):
    def configure(self, program, domains, destinations, sources):
        self.program = program
        self.domains = domains
        self.destinations = destinations
        self.sources = sources

    def mux(self, condition, yes, no):
        if condition is True:
            return yes
        if condition is False:
            return no
        if yes == no:
            return yes
        result = self.new()
        self.cl(self.neg(condition), self.neg(yes), result)
        self.cl(self.neg(condition), yes, -result)
        self.cl(condition, self.neg(no), result)
        self.cl(condition, no, -result)
        return result

    def add_type(self, ranks):
        start = len(self.clauses)
        top = max(ranks) + 1
        values = top + 1
        val = [[v == (ranks[r] if r < self.n else top)
                for v in range(values)] for r in range(self.R)]
        lt = gt = False
        nvs = []
        for i in range(self.k):
            domain = self.domains[i]
            def select(row, fixed):
                if fixed is not None:
                    return val[fixed]
                result = [self.new() for _ in range(values)]
                for r in range(self.R):
                    for v in range(values):
                        self.cl(-row[r], self.neg(val[r][v]), result[v])
                        self.cl(-row[r], val[r][v], -result[v])
                return result
            dv = select(self.d[i], self.destinations[i])
            sv = select(self.s[i], self.sources[i])
            if domain == ['cmp']:
                nv = dv
            else:
                conditions = {'mov':True, 'cmp':False,
                              'cmovl':lt, 'cmovle':self.neg(gt),
                              'cmovg':gt, 'cmovge':self.neg(lt)}
                if len(domain) == 1:
                    wr = conditions[domain[0]]
                else:
                    wr = self.new()
                    for op in domain:
                        flag = conditions[op]
                        self.cl(-self.op[i][op], self.neg(flag), wr)
                        self.cl(-self.op[i][op], flag, -wr)
                nv = [self.mux(wr, sv[v], dv[v]) for v in range(values)]
                fixed = self.destinations[i]
                if fixed is not None:
                    val = list(val)
                    val[fixed] = nv
                else:
                    val = [[self.mux(self.d[i][r], nv[v], val[r][v])
                            for v in range(values)] for r in range(self.R)]
            nvs.append(nv)
            if 'cmp' in domain and i + 1 < self.k:
                if all(isinstance(v,bool) for v in dv+sv):
                    left, right = dv.index(True), sv.index(True)
                    nlt, ngt = left < right, left > right
                else:
                    nlt, ngt = self.new(), self.new()
                    for u in range(values):
                        for v in range(values):
                            self.cl(self.neg(dv[u]), self.neg(sv[v]), nlt if u < v else -nlt)
                            self.cl(self.neg(dv[u]), self.neg(sv[v]), ngt if u > v else -ngt)
                if domain == ['cmp']:
                    lt, gt = nlt, ngt
                else:
                    lt = self.mux(self.op[i]['cmp'], nlt, lt)
                    gt = self.mux(self.op[i]['cmp'], ngt, gt)
        for j, goal in enumerate(sorted(ranks)):
            for r in range(self.n):
                if ranks[r] != goal:
                    self.cl(-self.osnap[j][r])
            for i in range(self.k):
                self.cl(-self.osnap[j][self.n+i], nvs[i][goal])
        for r,order in getattr(self,'final_targets',()):
            self.cl(val[r][sorted(ranks)[order]])
        for order,selectors in getattr(self,'role_targets',()):
            for r,literal in enumerate(selectors):
                self.cl(-literal,val[r][sorted(ranks)[order]])
        self.types.append(tuple(ranks))
        return start
