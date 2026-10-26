# n=5 model=out iset=I1 prefix14_class=13377
mov S0, P1
cmp P3, P2
cmovge S2, P3
cmovg P3, P2
cmovge P2, S2
cmp P0, S0
cmovl S0, P0
cmovge P1, P0
cmp S0, P3
mov S1, P2
cmovge P0, S0
cmovge S0, P3
cmovg P3, P0
cmp S1, P1
