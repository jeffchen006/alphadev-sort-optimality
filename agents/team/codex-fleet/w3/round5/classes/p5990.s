# n=5 model=out iset=I1 prefix14_class=5990
cmp P2, P1
mov S1, P1
mov S0, P3
cmovge P1, P2
cmovl S1, P2
cmp P0, S0
cmovge S0, P0
mov S2, S0
cmovl P3, P0
cmp P1, S2
cmovg S2, P1
cmovge P1, S0
cmp S1, P3
cmovge S2, P3
