# n=5 model=out iset=I1 prefix14_class=3322
cmp P0, P3
mov S2, P3
cmovge P3, P0
mov S0, P1
cmovl S2, P0
cmp S0, P2
cmovg P1, P2
cmovge P2, S0
cmp S2, P1
cmovle S1, S2
cmovge S1, P1
cmovl S2, P1
cmp P2, P3
cmovge S1, P3
