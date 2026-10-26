# n=5 model=out iset=I1 prefix14_class=5103
mov S2, P3
cmp P3, P1
cmovg P3, P1
cmovl S2, P1
mov S0, P3
cmp P2, P0
cmovl S1, P0
cmovge S1, P2
cmovg P2, P0
cmp S0, P2
cmovl P3, P2
cmovl P2, S0
cmp S2, S1
cmovge P0, S1
