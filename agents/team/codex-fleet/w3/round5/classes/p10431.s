# n=5 model=out iset=I1 prefix14_class=10431
cmp P3, P2
cmovl S1, P2
cmovle P2, P3
cmovge S1, P3
mov S0, P0
cmp P1, P0
cmovle P0, P1
cmovl P1, S0
cmp P1, S1
cmovle P3, P1
mov S2, P0
cmovle P1, S1
cmovle S1, P3
cmp P2, P0
