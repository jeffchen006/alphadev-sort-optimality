# n=5 model=out iset=I1 prefix14_class=2471
mov S1, P1
cmp P1, P0
cmovge P1, P0
cmovl S1, P0
cmp P2, P3
cmovge S0, P3
mov P0, S1
cmovg P3, P2
cmovge P2, S0
cmp S1, P3
cmovl P0, P3
cmovl P3, S1
mov S2, P1
cmp P2, S2
