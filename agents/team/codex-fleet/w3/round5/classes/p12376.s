# n=5 model=out iset=I1 prefix14_class=12376
mov S2, P0
cmp P2, P0
cmovl P0, P2
cmovl P2, S2
cmp P1, P3
cmovge S1, P3
cmovle S1, P1
cmovl P1, P3
cmp S1, P0
mov S0, P0
cmovle P0, S1
cmovle S1, S0
cmp P1, P2
cmovg P0, P2
