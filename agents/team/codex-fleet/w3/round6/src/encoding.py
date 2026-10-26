"""Local routing encoding, extended with unlimited fresh high scratch defaults.

The extra scratch mode relaxes arbitrary garbage by assigning every initial
scratch register the same high sentinel. A sentinel default creates a fresh
physical register without a counted copy. Other defaults still consume nodes.
"""
import itertools
from insertion_sat import CNF, OPS, run

class Enc(CNF):
    def __init__(self, prefix, types, comparisons, data, fixed=None, free_copies=False, origin=False, scratch=False):
        super().__init__()
        self.prefix = prefix
        self.types = types
        self.c = comparisons
        self.m = data
        self.free_copies = free_copies
        self.origin = origin
        self.scratch = scratch
        rows = [run(prefix, ty) for ty in types]
        if free_copies or scratch:
            for row in rows:
                row[0]['S99'] = 5
        self.names = sorted(set().union(*(r[0] for r in rows)))
        self.sentinel = self.names.index('S99') if scratch else None
        B = self.B = len(self.names)
        T = len(types)
        C = comparisons + 1
        M = data
        self.mov = self.vec(M)
        self.dst = [self.vec(B + g) for g in range(M)]
        self.src = [self.vec(B + g) for g in range(M)]
        self.blk = [self.vec(C) for g in range(M)]
        self.op = [self.vec(4) for g in range(M)]
        self.cmps = [[self.vec(B + M), self.vec(B + M)] for j in range(comparisons)]
        self.cmpval = []
        self.out = [self.vec(B + M) for j in range(5)]
        def value(t,name):
            v=rows[t][0][name]
            return types[t].index(v) if origin and v<5 else v
        self.val = [[[bool((value(t,name) >> b) & 1) for b in range(3)] for t in range(T)] for name in self.names]
        self.val += [[self.vec(3) for t in range(T)] for g in range(M)]
        self.flags = [[[rows[t][1] == f for f in (-1, 0, 1)] for t in range(T)]]
        self.flags += [[self.vec(3) for t in range(T)] for j in range(comparisons)]
        for j in range(1, C):
            for row in self.flags[j]:
                self.eo(row)
        for g in range(M):
            for ls in (self.dst[g], self.src[g], self.blk[g], self.op[g]):
                self.eo(ls)
            self.cl(-self.mov[g], self.dst[g][0])
            self.cl(-self.mov[g], self.op[g][0])
            if g:
                for j in range(C):
                    for k in range(j):
                        self.cl(-self.blk[g - 1][j], -self.blk[g][k])
            # Reading a consumed node is forbidden. A copied node stays live.
            if not free_copies:
                for x, dst in enumerate(self.dst[g]):
                    if x == self.sentinel:
                        continue
                    for h in range(g + 1, M):
                        self.cl(self.mov[g], -dst, -self.src[h][x])
                        self.cl(self.mov[g], -dst, self.mov[h], -self.dst[h][x])
                    for j in range(comparisons):
                        for phase in range(j + 1):
                            for side in range(2):
                                self.cl(self.mov[g], -dst, -self.blk[g][phase], -self.cmps[j][side][x])
        # Comparison j occurs between data phases j and j+1.
        for j in range(comparisons):
            cv = [[self.vec(3) for t in range(T)] for side in range(2)]
            self.cmpval.append(cv)
            for side in range(2):
                self.eo(self.cmps[j][side])
                for x, pick in enumerate(self.cmps[j][side]):
                    if x >= B:
                        self.cl(-pick, *self.blk[x - B][:j + 1])
                    for t in range(T):
                        for b in range(3):
                            self.eq(cv[side][t][b], self.val[x][t][b], -pick)
            # Compare both selected values. All ranks lie in 0..4.
            for t in range(T):
                for u, v in itertools.product(range(6), repeat=2):
                    guard = [self.neg(cv[0][t][b]) if (u >> b) & 1 else cv[0][t][b] for b in range(3)]
                    guard += [self.neg(cv[1][t][b]) if (v >> b) & 1 else cv[1][t][b] for b in range(3)]
                    au=types[t][u] if origin and u<5 else u
                    av=types[t][v] if origin and v<5 else v
                    f = (au > av) - (au < av)
                    self.cl(*guard, self.flags[j + 1][t][f + 1])
        for g in range(M):
            dv = [self.vec(3) for t in range(T)]
            sv = [self.vec(3) for t in range(T)]
            for x in range(B + g):
                for t in range(T):
                    for b in range(3):
                        self.eq(dv[t][b], self.val[x][t][b], -self.dst[g][x])
                        self.eq(sv[t][b], self.val[x][t][b], -self.src[g][x])
            for t in range(T):
                for b in range(3):
                    self.eq(self.val[B + g][t][b], sv[t][b], -self.mov[g])
                for j in range(C):
                    for f in range(3):
                        flag = self.flags[j][t][f]
                        if flag is False:
                            continue
                        for op in range(4):
                            take = (f < 1, f <= 1, f > 1, f >= 1)[op]
                            vv = sv[t] if take else dv[t]
                            guard = [self.mov[g], -self.blk[g][j], self.neg(flag), -self.op[g][op]]
                            for b in range(3):
                                self.eq(self.val[B + g][t][b], vv[b], *guard)
        for j, ls in enumerate(self.out):
            self.eo(ls)
            for x, pick in enumerate(ls):
                for t, ty in enumerate(types):
                    target = ty.index(j) if origin else sorted(ty)[j]
                    for b in range(3):
                        self.cl(-pick, self.val[x][t][b] if (target >> b) & 1 else self.neg(self.val[x][t][b]))
        if fixed:
            self.fix(fixed)

    def fix(self, program):
        cur = {name: x for x, name in enumerate(self.names)}
        def current(name):
            if name in cur:
                return cur[name]
            assert self.scratch, 'unknown register in fixed program: '+name
            return self.sentinel
        j = g = 0
        for op, d, s in program:
            if op == 'out':
                self.cl(self.out[int(d)][cur[s]])
            elif op == 'cmp':
                self.cl(self.cmps[j][0][current(d)])
                self.cl(self.cmps[j][1][current(s)])
                j += 1
            else:
                if self.free_copies and op=='mov':
                    cur[d]=cur[s]
                    continue
                self.cl(self.mov[g] if op == 'mov' else -self.mov[g])
                self.cl(self.blk[g][j])
                self.cl(self.src[g][current(s)])
                if op != 'mov':
                    self.cl(self.dst[g][current(d)])
                    self.cl(self.op[g][OPS.index(op)])
                cur[d] = self.B + g
                g += 1
        assert g == self.m and j == self.c

    def decode(self, model):
        yes = set(x for x in model if x > 0)
        idx = lambda xs: next(i for i, x in enumerate(xs) if x in yes)
        reg = {i: n for i, n in enumerate(self.names)}
        outputs = {j: idx(xs) for j, xs in enumerate(self.out)}
        lines = ['# n=5 model=out iset=I1 source=w3_sort4_interleave']
        lines += [f'{op} {d}, {s}' for op, d, s in self.prefix if op != 'out']
        for j, x in outputs.items():
            if x < self.B:
                lines.append(f'out {j}, {reg[x]}')
        g = 0
        for phase in range(self.c + 1):
            if phase:
                d, s = [idx(xs) for xs in self.cmps[phase - 1]]
                lines.append(f'cmp {reg[d]}, {reg[s]}')
            while g < self.m and idx(self.blk[g]) == phase:
                d, s = idx(self.dst[g]), idx(self.src[g])
                ismov = self.mov[g] in yes
                fresh_scratch = self.scratch and not ismov and d == self.sentinel
                if ismov or self.free_copies or fresh_scratch:
                    name = f'S{100 + g}'
                    if self.free_copies and not ismov and not fresh_scratch:
                        lines.append(f'mov {name}, {reg[d]}')
                else:
                    name = reg[d]
                lines.append(f'{"mov" if ismov else OPS[idx(self.op[g])]} {name}, {reg[s]}')
                reg[self.B + g] = name
                for j, x in outputs.items():
                    if x == self.B + g:
                        lines.append(f'out {j}, {name}')
                g += 1
        assert g == self.m
        return '\n'.join(lines) + '\n'
