# n=5 model=out iset=I1 prefix14_class=2376
cmp P2, P1
cmovl S0, P2
mov S1, P3
cmovge S0, P1
cmovg P1, P2
cmp P0, S1
mov S2, P1
cmovl S1, P0
cmovge P3, P0
cmp P1, P3
cmovl P1, P3
cmovl P3, S2
cmp S0, S1
cmovge S2, S0
