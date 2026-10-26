# n=5 model=out iset=I1 prefix14_class=199
mov S1, P2
cmp P3, P0
mov S2, P3
cmovle P3, P0
cmovl P0, S2
cmovle S2, P3
cmp S1, P1
cmovge S1, P1
cmovge P1, P2
cmp P0, S1
cmovle S0, P0
cmovl P0, S1
cmovle S1, S0
cmp S2, P1
