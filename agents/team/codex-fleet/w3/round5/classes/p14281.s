# n=5 model=out iset=I1 prefix14_class=14281
cmp P0, P1
cmovle S1, P1
cmovle P1, P0
mov S0, P2
cmovle P0, S1
cmp P3, S0
cmovg P2, P3
cmovle S0, P3
cmovl P3, P2
cmp P2, P0
cmovl P3, P0
cmovle P0, P2
cmp P1, S0
cmovge S2, S0
