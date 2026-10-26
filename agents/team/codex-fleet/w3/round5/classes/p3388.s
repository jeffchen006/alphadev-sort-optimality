# n=5 model=out iset=I1 prefix14_class=3388
mov S1, P2
cmp P3, P1
mov S2, P1
cmovge P1, P3
cmovl S2, P3
cmp P0, S1
cmovge P2, P0
cmovl S1, P0
mov S0, S2
cmp S1, S0
cmovge S2, S1
cmovg S1, S0
cmp P2, P1
cmovl S1, P1
