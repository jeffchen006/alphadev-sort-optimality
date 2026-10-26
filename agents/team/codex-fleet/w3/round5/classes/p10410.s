# n=5 model=out iset=I1 prefix14_class=10410
mov S0, P1
cmp P1, P0
cmovge S0, P0
cmovl P1, P0
cmp P2, P3
cmovge S2, P3
cmovl S2, P2
cmovge P3, P2
cmp P1, P3
mov S1, P1
cmovge P1, P3
cmovge P3, S1
cmp S0, S2
cmovge P2, S2
