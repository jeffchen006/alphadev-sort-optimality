# n=5 model=out iset=I1 prefix14_class=5186
mov S1, P2
cmp S1, P3
cmovle P2, P3
cmovl P3, S1
cmp P1, P0
cmovl S1, P0
cmovl P0, P1
cmovl P1, S1
cmp P0, P3
cmovge S1, P0
cmovge P0, P3
cmovg P3, S1
mov P0, P1
cmp P2, P0
