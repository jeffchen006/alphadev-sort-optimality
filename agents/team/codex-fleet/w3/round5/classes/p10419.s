# n=5 model=out iset=I1 prefix14_class=10419
mov S0, P1
cmp P1, P0
cmovl S0, P0
cmovg P1, P0
cmp P2, P3
mov S2, P3
cmovg P3, P2
cmovl S2, P2
cmp S0, P3
cmovge P0, S0
cmovge S0, P3
cmovge P3, P0
cmp P1, S2
mov S1, S2
