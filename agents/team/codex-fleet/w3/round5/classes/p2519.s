# n=5 model=out iset=I1 prefix14_class=2519
cmp P1, P0
cmovle S0, P0
cmovle P0, P1
cmovle P1, S0
cmp P2, P3
cmovl S2, P3
cmovge S2, P2
mov S1, P1
cmovl P3, P2
cmp S1, S2
cmovge P1, S2
cmovl S1, S2
cmp P3, P0
cmovge S0, P3
