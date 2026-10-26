# n=5 model=out iset=I1 prefix14_class=11047
cmp P1, P2
mov S2, P0
cmovle S1, P1
cmovle P1, P2
cmovl P2, S1
cmp P0, P3
cmovle S2, P3
cmovle P3, P0
cmp S2, P1
cmovge S0, P1
cmovl S0, S2
cmovle S2, P1
cmp P3, P2
mov P1, P3
