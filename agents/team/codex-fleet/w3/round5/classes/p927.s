# n=5 model=out iset=I1 prefix14_class=927
cmp P1, P2
cmovl S2, P2
cmovge S2, P1
mov S0, P3
cmovl P2, P1
cmp P3, P0
cmovge S0, P0
cmovg P0, P3
mov P3, S2
cmp P0, S2
cmovg P3, P0
cmovg P0, S2
cmp S0, P2
cmovl S2, P0
