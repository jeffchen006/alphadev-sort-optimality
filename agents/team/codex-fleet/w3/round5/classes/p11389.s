# n=5 model=out iset=I1 prefix14_class=11389
cmp P0, P3
mov S2, P1
cmovge S0, P3
cmovle S0, P0
cmovle P0, P3
cmp P1, P2
cmovl P1, P2
cmovge S2, P2
cmp P1, P0
cmovle S1, P0
cmovl P0, P1
cmovle P1, S1
cmp S2, S0
mov P1, S0
