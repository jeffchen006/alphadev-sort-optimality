# n=5 model=out iset=I1 prefix14_class=11206
cmp P0, P1
cmovle S2, P1
cmovle P1, P0
cmovle P0, S2
cmp P3, P2
cmovl S1, P3
cmovle P3, P2
cmovl P2, S1
cmp P3, P0
cmovl S1, P3
cmovle P3, P0
mov P3, P1
cmovge S1, P0
cmp P2, P1
