# n=5 model=out iset=I1 prefix14_class=10996
cmp P3, P2
cmovl S1, P3
cmovl P3, P2
cmovge S1, P2
cmp P1, P0
cmovl S2, P1
cmovle P1, P0
cmovl P0, S2
mov P2, P1
cmp P2, P3
cmovle P2, P3
cmovl P3, P1
cmp S1, P0
cmovle P1, P0
