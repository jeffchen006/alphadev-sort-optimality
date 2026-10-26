# n=5 model=out iset=I1 prefix14_class=12349
mov S1, P2
cmp P2, P1
cmovl P2, P1
cmovl P1, S1
cmp P0, P3
mov S2, P0
cmovge S2, P3
cmovle P0, P3
cmp P1, S2
cmovle S0, P1
cmovle P1, S2
cmovle S2, S0
cmp P0, P2
mov S2, P0
