# n=5 model=out iset=I1 prefix14_class=6358
cmp P3, P1
cmovge S2, P3
cmovge P3, P1
mov S1, P2
cmovge P1, S2
mov S0, P1
cmp P2, P0
cmovge S1, P0
cmovge P0, P2
cmp P0, P1
cmovge P1, P0
cmovl S0, P0
cmp S1, P3
cmovl P0, S1
