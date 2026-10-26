# n=5 model=out iset=I1 prefix14_class=2319
mov S0, P0
cmp P0, P2
cmovge S0, P2
cmovl P0, P2
mov S1, P3
cmp S1, P1
cmovge P3, P1
cmovl S1, P1
cmp P0, S1
cmovl S2, S1
cmovge S2, P0
cmovl S1, P0
cmp S0, P3
cmovge P0, S0
