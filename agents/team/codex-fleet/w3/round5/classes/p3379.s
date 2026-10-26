# n=5 model=out iset=I1 prefix14_class=3379
mov S2, P2
mov S0, P1
cmp P3, S2
cmovl P2, P3
cmovg S2, P3
cmp P0, P1
cmovl S0, P0
cmovg P1, P0
cmp P2, S0
mov S1, S0
cmovge S1, P2
cmovg P2, S0
cmp S2, P1
cmovg S0, S1
