# n=5 model=out iset=I1 prefix14_class=10806
mov S0, P2
cmp P0, S0
cmovl P2, P0
cmovge S0, P0
cmp P3, P1
cmovl S1, P3
cmovle P3, P1
cmovl P1, S1
cmp S0, P3
cmovle S1, S0
cmovle S0, P3
cmovl P3, S1
cmp P1, P2
cmovl S2, P2
