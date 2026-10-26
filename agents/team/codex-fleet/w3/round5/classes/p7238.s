# n=5 model=out iset=I1 prefix14_class=7238
cmp P0, P1
mov S1, P1
cmovl S1, P0
cmovl P0, P1
cmp P2, P3
cmovl S0, P3
cmovge S0, P2
cmovg P2, P3
cmp S1, P2
cmovge S2, S1
cmovg S1, P2
cmovg P2, S2
mov P1, P0
cmp S0, P1
