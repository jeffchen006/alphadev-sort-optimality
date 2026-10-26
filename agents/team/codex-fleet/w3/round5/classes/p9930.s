# n=5 model=out iset=I1 prefix14_class=9930
mov S1, P3
cmp S1, P1
cmovle P3, P1
cmovle P1, S1
cmp P2, P0
cmovl S1, P0
cmovge S1, P2
cmovl P0, P2
cmp P3, S1
mov P2, P3
cmovg P2, S1
cmovle P3, S1
cmp P0, P1
mov P3, P2
