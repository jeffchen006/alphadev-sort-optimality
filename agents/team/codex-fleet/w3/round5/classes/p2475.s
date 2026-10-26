# n=5 model=out iset=I1 prefix14_class=2475
cmp P0, P2
cmovge S0, P0
cmovl S0, P2
cmovg P0, P2
cmp P1, P3
mov S2, P3
cmovge S2, P1
cmovge P1, P3
mov S1, S0
cmp S1, S2
cmovl S0, S2
cmovl S2, S1
cmp P1, P0
mov S0, P0
