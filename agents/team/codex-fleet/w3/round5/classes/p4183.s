# n=5 model=out iset=I1 prefix14_class=4183
mov S1, P3
cmp P0, S1
cmovl P3, P0
cmovge S1, P0
cmp P1, P2
mov S2, P3
mov P0, P1
cmovl P1, P2
cmovl P2, P0
cmp P2, P3
cmovl S2, P2
cmovg P3, P2
cmp P1, S1
cmovg P2, P1
