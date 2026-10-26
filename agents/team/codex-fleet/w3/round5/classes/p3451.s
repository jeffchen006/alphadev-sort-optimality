# n=5 model=out iset=I1 prefix14_class=3451
mov S1, P2
mov S0, P3
cmp P0, S0
cmovge S0, P0
cmovg P0, P3
cmp S1, P1
cmovl S1, P1
cmovg P2, P1
cmp P2, P0
mov S2, S1
cmovge P1, P0
cmovge P0, P2
cmovge P2, P1
cmp S0, S2
