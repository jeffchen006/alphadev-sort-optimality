# n=5 model=out iset=I1 prefix14_class=11441
cmp P3, P2
mov S1, P2
cmovge S1, P3
cmovge P3, P2
mov S0, P3
mov S2, P0
cmp P1, P0
cmovl S2, P1
cmovg P0, P1
cmp S0, S2
cmovl S0, S2
cmovg P3, S2
cmp P0, S1
cmovge P2, S1
