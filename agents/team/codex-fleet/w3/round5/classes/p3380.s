# n=5 model=out iset=I1 prefix14_class=3380
mov S2, P2
mov S0, P0
cmp P3, S2
cmovge S2, P3
cmovl P2, P3
cmp P1, P0
cmovl S0, P1
cmovg P0, P1
cmp P2, S0
cmovl S1, S0
cmovge S1, P2
cmovg P2, S0
cmp S2, P0
cmovg S0, S1
