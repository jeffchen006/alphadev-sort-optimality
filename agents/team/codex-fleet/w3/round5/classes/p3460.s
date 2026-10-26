# n=5 model=out iset=I1 prefix14_class=3460
mov S0, P0
cmp P1, P0
cmovge S0, P1
mov S1, P3
cmovg P1, P0
cmp S1, P2
cmovge P3, P2
cmovl S1, P2
cmp P1, P3
cmovge P0, P3
cmovg P3, P1
cmovg P1, P0
mov S2, S1
cmp S0, S1
