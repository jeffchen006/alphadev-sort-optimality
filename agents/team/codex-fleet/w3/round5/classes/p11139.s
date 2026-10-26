# n=5 model=out iset=I1 prefix14_class=11139
cmp P3, P1
cmovle S1, P3
cmovl P3, P1
cmovl P1, S1
cmp P0, P2
mov S1, P0
cmovge S1, P2
cmovl P0, P2
cmp P3, P0
cmovle S2, P3
cmovle P3, P0
mov P3, P1
cmovl P0, S2
mov P2, P0
