# n=5 model=out iset=I1 prefix14_class=3723
mov S1, P3
cmp P3, P2
cmovle P3, P2
cmovl P2, S1
cmp P1, P0
cmovge S1, P1
cmovl S1, P0
cmovle P0, P1
mov P1, P0
cmp P2, P1
cmovle P0, P2
cmovg P1, P2
cmp S1, P3
cmovg P0, P3
