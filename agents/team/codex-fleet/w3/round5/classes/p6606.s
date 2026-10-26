# n=5 model=out iset=I1 prefix14_class=6606
cmp P2, P3
cmovl S0, P3
cmovge S0, P2
mov S1, P1
cmovle P3, P2
cmp S1, P0
cmovle S1, P0
cmovle P0, P1
cmp S0, S1
cmovge S2, S1
cmovl S2, S0
cmovle S0, S1
cmp P3, P0
cmovge P2, P0
