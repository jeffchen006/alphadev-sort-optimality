# n=5 model=out iset=I1 prefix14_class=11388
cmp P0, P2
mov S2, P1
cmovle S0, P0
cmovge S0, P2
cmovle P0, P2
cmp P1, P3
cmovl P1, P3
cmovge S2, P3
cmp P1, P0
cmovle S1, P0
cmovl P0, P1
cmovle P1, S1
cmp S2, S0
mov P1, S0
