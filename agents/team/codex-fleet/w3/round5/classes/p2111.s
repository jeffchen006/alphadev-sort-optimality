# n=5 model=out iset=I1 prefix14_class=2111
cmp P0, P1
cmovge S1, P1
cmovl S1, P0
cmovg P1, P0
mov S2, P2
cmp P2, P3
cmovl S2, P3
cmovg P2, P3
cmp P1, S2
mov S0, S2
cmovge S2, P1
cmovg P1, S0
cmp S1, P2
cmovge S2, S1
