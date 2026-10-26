# n=5 model=out iset=I1 prefix14_class=14085
cmp P0, P2
mov S2, P3
cmovle S1, P0
cmovle P0, P2
cmovle P2, S1
cmp P1, S2
cmovge S2, P1
cmovl P3, P1
cmp P0, S2
cmovle P1, S2
cmovl S2, P0
cmovl P0, P1
cmp P2, P3
cmovl S0, P3
