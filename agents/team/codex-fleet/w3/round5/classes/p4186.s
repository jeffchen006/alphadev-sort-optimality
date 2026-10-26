# n=5 model=out iset=I1 prefix14_class=4186
mov S1, P3
cmp P0, P3
cmovl P3, P0
cmovge S1, P0
mov P0, P3
cmp P1, P2
cmovl S2, P1
cmovle P1, P2
cmovl P2, S2
cmp P2, P0
cmovg P0, P2
cmovl P3, P2
cmp P1, S1
mov P2, P1
