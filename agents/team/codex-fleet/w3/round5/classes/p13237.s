# n=5 model=out iset=I1 prefix14_class=13237
cmp P2, P3
cmovle S1, P3
cmovl P3, P2
cmovle P2, S1
cmp P0, P1
cmovge S1, P1
cmovl S1, P0
cmovl P0, P1
cmp S1, P3
cmovle S0, P3
cmovle P3, S1
cmovle S1, S0
mov P3, P2
cmp P2, P0
