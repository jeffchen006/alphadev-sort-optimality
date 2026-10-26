# n=5 model=out iset=I1 prefix14_class=6659
cmp P0, P3
cmovl S0, P3
cmovle P3, P0
cmovge S0, P0
cmp P1, P2
cmovg S1, P1
mov S2, S0
cmovge P1, P2
cmovle S1, P2
cmp S1, S2
cmovg S0, S1
cmovle S2, S1
cmp P1, P3
cmovle S1, P3
