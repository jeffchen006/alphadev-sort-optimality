# n=5 model=out iset=I1 prefix14_class=9447
cmp P0, P2
mov S2, P0
cmovge P0, P2
cmovl S2, P2
mov S1, P1
cmp S1, P3
cmovge S1, P3
mov S0, S1
cmovl P1, P3
cmp P0, S0
cmovl S1, P0
cmovg S0, P0
cmp P1, S2
cmovge P2, S2
