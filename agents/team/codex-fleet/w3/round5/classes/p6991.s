# n=5 model=out iset=I1 prefix14_class=6991
mov S1, P2
cmp P0, P2
cmovge P2, P0
cmovl S1, P0
cmp P3, P1
mov S2, P1
mov S0, S1
cmovle S2, P3
cmovle P3, P1
cmp S2, S1
cmovl S1, S2
cmovge S0, S2
cmp P2, P3
cmovge S1, P2
