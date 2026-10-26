# n=5 model=out iset=I1 prefix14_class=4336
cmp P2, P3
cmovge S0, P3
cmovle S0, P2
cmovle P2, P3
cmp P0, P1
cmovl P3, P1
cmovl P1, P0
cmovl P0, P3
cmp S0, P1
cmovle S2, S0
cmovle S0, P1
cmovl P1, S2
cmp P2, P0
cmovl S1, P0
