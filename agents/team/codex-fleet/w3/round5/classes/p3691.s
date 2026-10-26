# n=5 model=out iset=I1 prefix14_class=3691
cmp P0, P2
cmovle S1, P2
cmovge S1, P0
cmovle P2, P0
cmp P3, P1
cmovle S2, P3
cmovle P3, P1
mov S0, P2
cmovl P1, S2
cmp P2, P1
cmovl S0, P1
cmovl P1, P2
mov P1, S1
cmp P3, P1
