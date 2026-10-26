# n=5 model=out iset=I1 prefix14_class=3396
cmp P1, P3
mov S2, P3
mov S1, P2
cmovge P3, P1
cmovl S2, P1
cmp P0, P2
cmovl S1, P0
cmovg P2, P0
mov S0, S1
cmp S2, S1
cmovge S0, S2
cmovge S2, S1
cmp P2, P3
mov S2, S0
