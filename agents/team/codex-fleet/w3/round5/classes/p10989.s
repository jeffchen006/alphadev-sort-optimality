# n=5 model=out iset=I1 prefix14_class=10989
mov S2, P2
cmp P1, S2
cmovl P2, P1
cmovle P1, S2
cmp P0, P3
cmovl S2, P0
cmovl P0, P3
mov S1, P0
cmovl P3, S2
cmp S1, P1
cmovle S1, P1
cmovl P1, P0
cmp P2, P3
cmovl P0, P3
