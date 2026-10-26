# n=5 model=out iset=I1 prefix14_class=13118
mov S1, P1
cmp P3, P2
cmovle S0, P2
cmovl P2, P3
cmovl P3, S0
cmp S1, P0
cmovle S1, P0
cmovl P0, P1
cmovl P1, S1
cmp P2, P0
cmovle S2, P0
cmovle P0, P2
cmovle P2, S2
cmp P1, P3
