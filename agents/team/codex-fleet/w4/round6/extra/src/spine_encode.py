"""Free data routing around fixed comparison-value columns.

The top value represents any input-independent scratch value. No comparison
may read top. Data moves can read it. Therefore a decoded program whose full
columns satisfy this model is independent of all scratch values. The fixed
comparison columns are a search restriction, not a completeness theorem.
"""
from encode import Enc


class SpineEnc(Enc):
    def configure(self, program, domains, destinations, sources, comparisons):
        self.program = program
        self.domains = domains
        self.destinations = destinations
        self.sources = sources
        self.comparisons = comparisons

    def mux(self, condition, yes, no):
        if condition is True:
            return yes
        if condition is False:
            return no
        if type(yes) is type(no) and yes == no:
            return yes
        result = self.new()
        self.cl(self.neg(condition), self.neg(yes), result)
        self.cl(self.neg(condition), yes, -result)
        self.cl(condition, self.neg(no), result)
        self.cl(condition, no, -result)
        return result

    def add_case(self, case_index, ranks):
        top = max(ranks) + 1
        values = top + 1
        val = [[v == (ranks[r] if r < self.n else top)
                for v in range(values)] for r in range(self.R)]
        # Initial flags are equality. Strict acceptance still uses the judge.
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
                        self.cl(self.neg(row[r]), self.neg(val[r][v]), result[v])
                        self.cl(self.neg(row[r]), val[r][v], -result[v])
                return result

            dv = select(self.d[i], self.destinations[i])
            sv = select(self.s[i], self.sources[i])
            if domain == ['cmp']:
                left, right = [column[case_index] for column in self.comparisons[i]]
                assert left is not None and right is not None
                self.cl(dv[left])
                self.cl(sv[right])
                lt, gt = left < right, left > right
                nv = dv
            else:
                conditions = {'mov': True, 'cmovl': lt, 'cmovle': not gt,
                              'cmovg': gt, 'cmovge': not lt}
                # All comparisons have fixed value columns, so each condition
                # is a constant in a case. Only the opcode remains symbolic.
                if len(domain) == 1:
                    wr = conditions[domain[0]]
                else:
                    wr = self.new()
                    for op in domain:
                        self.cl(-self.op[i][op], wr if conditions[op] else -wr)
                nv = [self.mux(wr, sv[v], dv[v]) for v in range(values)]
                fixed = self.destinations[i]
                if fixed is not None:
                    val = list(val)
                    val[fixed] = nv
                else:
                    val = [[self.mux(self.d[i][r], nv[v], val[r][v])
                            for v in range(values)] for r in range(self.R)]
            nvs.append(nv)
        for j, goal in enumerate(sorted(ranks)):
            for r in range(self.n):
                if ranks[r] != goal:
                    self.cl(-self.osnap[j][r])
            for i in range(self.k):
                self.cl(-self.osnap[j][self.n+i], nvs[i][goal])
        self.types.append(case_index)
