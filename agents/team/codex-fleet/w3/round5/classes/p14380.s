# n=5 model=out iset=I1 prefix14_class=14380
cmp P2, P0
mov S2, P2
cmovl P2, P0
cmovg S2, P0
cmp P3, P1
cmovge S1, P3
mov P0, P2
mov S0, S2
cmovge P3, P1
cmovge P1, S1
cmp S0, P3
cmovl S0, P3
cmovl P3, S2
mov S2, S0
