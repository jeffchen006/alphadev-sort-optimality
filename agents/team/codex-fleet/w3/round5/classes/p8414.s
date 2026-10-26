# n=5 model=out iset=I1 prefix14_class=8414
mov S1, P3
cmp S1, P1
cmovge S1, P1
mov S2, P0
cmovg P1, P3
cmp P2, S2
cmovge P0, P2
cmovl S2, P2
cmp P1, P0
cmovge P2, P0
cmovge P0, P1
cmovg P1, P2
mov S0, S1
cmp S2, S1
