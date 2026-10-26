# n=5 model=out iset=I1 prefix14_class=7989
cmp P0, P3
cmovge S0, P3
mov S1, P1
cmovge P3, P0
cmovge P0, S0
cmp S1, P2
cmovg P1, P2
cmovge P2, S1
mov S2, P0
cmovl S1, P2
cmp S2, P1
cmovl S2, P1
cmovg P0, P1
cmp P3, S1
