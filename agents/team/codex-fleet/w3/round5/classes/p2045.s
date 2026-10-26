# n=5 model=out iset=I1 prefix14_class=2045
cmp P2, P0
mov S1, P0
cmovl S1, P2
cmovge P0, P2
mov S0, P1
cmp S0, P3
cmovg P1, P3
cmovg P3, S0
mov S2, P3
cmp P3, P0
cmovge S2, P0
cmovl P3, P0
cmp P1, S1
cmovl P0, S2
