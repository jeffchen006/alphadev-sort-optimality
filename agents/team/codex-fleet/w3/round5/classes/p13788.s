# n=5 model=out iset=I1 prefix14_class=13788
cmp P2, P0
cmovge S0, P2
mov S2, P3
cmovge P2, P0
cmovg P0, S0
cmp S2, P1
cmovge P3, P1
cmovl S2, P1
cmovge P1, S2
cmp P0, P1
cmovl S2, P0
cmovg P1, P0
cmp P2, P3
cmovl S1, P3
