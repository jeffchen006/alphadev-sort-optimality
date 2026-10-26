# n=5 model=out iset=I1 prefix14_class=3020
mov S0, P0
cmp P3, P2
cmovl S1, P3
cmovl P3, P2
cmovl P2, S1
cmp S0, P1
cmovg P0, P1
cmovge P1, S0
cmp P3, P1
cmovl S2, P3
cmovge S2, P1
cmovge P1, P3
cmp P0, P2
cmovge S1, P2
