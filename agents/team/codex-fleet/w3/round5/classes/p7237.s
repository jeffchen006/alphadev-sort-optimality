# n=5 model=out iset=I1 prefix14_class=7237
cmp P1, P0
mov S1, P0
cmovl S1, P1
cmovl P1, P0
cmp P2, P3
cmovl S0, P3
cmovge S0, P2
cmovg P2, P3
cmp S1, P2
cmovg S2, S1
cmovg S1, P2
cmovg P2, S2
mov P0, S0
cmp P1, P0
