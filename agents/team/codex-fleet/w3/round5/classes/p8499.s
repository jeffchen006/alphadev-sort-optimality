# n=5 model=out iset=I1 prefix14_class=8499
cmp P1, P3
cmovle S1, P3
cmovle P3, P1
cmovle P1, S1
mov S2, P2
cmp S2, P0
cmovle S2, P0
mov S0, S2
cmovl P0, P2
cmp P1, S2
cmovle S0, P1
cmovge S2, P1
cmp P0, P3
mov P1, P3
