# n=5 model=out iset=I1 prefix14_class=5368
mov S0, P0
mov S1, P1
cmp S1, P3
cmovge P1, P3
cmovle S1, P3
cmp P2, P0
cmovl S0, P2
cmovg P0, P2
cmp S0, P1
cmovl S2, S0
cmovge S2, P1
cmovge P1, S0
cmp P0, S1
cmovge S0, P0
