# n=5 model=out iset=I1 prefix14_class=8693
cmp P3, P0
cmovle S1, P3
cmovle P3, P0
cmovge S1, P0
cmp P1, P2
cmovl P0, P2
cmovle P2, P1
cmovl P1, P0
cmp P1, P3
cmovge S2, P1
cmovl S2, P3
cmovl P3, P1
mov P1, S1
cmp S1, P2
