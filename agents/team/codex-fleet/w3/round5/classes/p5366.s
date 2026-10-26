# n=5 model=out iset=I1 prefix14_class=5366
mov S0, P0
mov S1, P2
cmp S1, P3
cmovge P2, P3
cmovl S1, P3
cmp P1, P0
cmovg P0, P1
cmovl S0, P1
cmp S0, P2
cmovge S2, P2
cmovle S2, S0
cmovge P2, S0
cmp S1, P0
cmovge S0, S1
