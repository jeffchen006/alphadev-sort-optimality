s=open('ext_sat.py').read()
s=s.replace("""        for j in range(n):
            self.eo([v for row in self.o[j] for v in row])""","""        for j in range(n):
            self.eo([v for row in self.o[j] for v in row])
            # output snapshot right after the instruction that wrote the register (or initial state)
            for t in range(1, K + 1):
                for r in range(R):
                    self.cl(-self.o[j][t][r], self.d[t - 1][r]); self.cl(-self.o[j][t][r], -self.op[t - 1][1])
                    self.cl(-self.o[j][t][r], -self.op[t - 1][6])
        # free cmp: operands in index order (cmp b,a == cmp a,b with mirrored cmovs; I1 has all 4)
        coreslot = lambda t: [self.x[c][t] for c in range(C)]
        for t in range(K):
            for r1 in range(R):
                for r2 in range(r1):
                    self.cl(-self.op[t][1], -self.d[t][r1], -self.s[t][r2], *coreslot(t))
            # two cmps in a row: the first is dead (sound)
            if t < K - 1:
                self.cl(-self.op[t][1], -self.op[t + 1][1])""")
open('ext_sat.py','w').write(s)
