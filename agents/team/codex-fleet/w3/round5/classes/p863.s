# n=5 model=out iset=I1 prefix14_class=863
cmp P2, P0
cmovge S2, P0
cmovl S2, P2
cmovl P2, P0
mov S0, P3
cmp P3, P1
cmovg P3, P1
cmovg P1, S0
cmovge S0, P3
mov S1, P2
cmp P1, S1
cmovl P2, P1
cmovge S1, P1
cmp S2, P3
