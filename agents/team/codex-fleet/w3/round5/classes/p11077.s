# n=5 model=out iset=I1 prefix14_class=11077
mov S1, P1
mov S2, P3
cmp S2, P0
cmovl P3, P0
cmovl P0, S2
cmp S1, P2
cmovl S1, P2
cmovle P2, P1
cmp P3, S1
cmovle P1, S1
cmovl S1, P3
cmovl P3, P1
cmp P0, P2
mov P3, P0
