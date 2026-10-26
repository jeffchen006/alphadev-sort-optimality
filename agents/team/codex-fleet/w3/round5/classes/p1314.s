# n=5 model=out iset=I1 prefix14_class=1314
mov S1, P0
cmp P3, P0
mov S2, P2
cmovl S1, P3
cmovl P3, P0
cmp S2, P1
cmovge S2, P1
cmovg P1, P2
cmp P3, P1
mov P0, P1
cmovg P1, P3
cmovle P0, P3
mov P3, S1
mov P1, P0
