# n=5 model=out iset=I1 prefix14_class=13463
cmp P3, P1
mov S2, P2
cmovl S1, P3
cmovl P3, P1
cmovl P1, S1
cmp P2, P0
cmovle P2, P0
cmovge S2, P0
cmp S2, P1
mov P0, S2
cmovle P0, P1
cmovle P1, S2
cmp P2, P3
mov P1, P2
