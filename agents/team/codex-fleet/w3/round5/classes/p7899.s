# n=5 model=out iset=I1 prefix14_class=7899
mov S0, P0
cmp P2, P0
cmovge S0, P2
cmovl P0, P2
cmp P1, P3
mov S2, P0
cmovge S1, P1
cmovge P1, P3
cmovg P3, S1
cmp S2, P1
cmovge P0, P1
cmovl S2, P1
cmp P3, S0
cmovl S1, P3
