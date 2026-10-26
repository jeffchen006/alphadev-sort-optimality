# n=5 model=out iset=I1 prefix14_class=6253
mov S1, P0
cmp S1, P2
cmovg S1, P2
cmovl P0, P2
mov S0, P3
cmp P1, S0
cmovl S0, P1
cmovge P3, P1
cmp P3, P0
cmovl S2, P0
cmovl P0, P3
cmovge S2, P3
cmp S1, S0
cmovge P1, S0
