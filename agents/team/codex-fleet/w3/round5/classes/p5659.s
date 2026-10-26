# n=5 model=out iset=I1 prefix14_class=5659
cmp P0, P3
cmovle S1, P3
cmovle P3, P0
cmovl P0, S1
cmp P1, P2
cmovle S1, P1
cmovl P1, P2
cmovg S1, P2
mov P2, P3
cmp S1, P2
cmovle P2, S1
cmovl S1, P3
cmp P1, P0
cmovle S2, P1
