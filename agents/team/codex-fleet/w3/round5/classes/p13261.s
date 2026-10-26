# n=5 model=out iset=I1 prefix14_class=13261
cmp P1, P2
cmovle S1, P2
cmovle P2, P1
cmovle P1, S1
mov S2, P3
cmp S2, P0
cmovl P3, P0
cmovle P0, S2
cmp P2, P0
cmovle S0, P0
cmovl P0, P2
cmovl P2, S0
cmp P3, P1
cmovge S2, P3
