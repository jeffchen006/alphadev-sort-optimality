# n=5 model=out iset=I1 prefix14_class=3603
mov S1, P3
cmp S1, P2
cmovle S1, P2
cmovl P2, P3
mov P3, P0
cmp P1, P0
cmovle P0, P1
cmovl P1, P3
cmovle P3, P0
cmp P2, P0
cmovle P0, P2
cmovl P2, P3
cmp P1, S1
cmovl S2, P1
