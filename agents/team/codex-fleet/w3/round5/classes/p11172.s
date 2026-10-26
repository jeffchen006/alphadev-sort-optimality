# n=5 model=out iset=I1 prefix14_class=11172
cmp P1, P0
cmovge S2, P1
cmovge P1, P0
cmovg P0, S2
cmp P2, P3
cmovl S1, P3
cmovl P3, P2
cmovge S1, P2
mov S0, P1
cmp S1, P0
cmovle S2, P0
cmovl P0, S1
cmovle S1, S2
cmp S0, P3
