# n=5 model=out iset=I1 prefix14_class=4477
cmp P3, P1
mov S2, P3
cmovg P3, P1
cmovl S2, P1
cmp P0, P2
cmovl S1, P0
cmovl P0, P2
cmovge S1, P2
cmp P0, S2
mov P1, P0
cmovg P0, S2
cmovge S2, P1
mov S2, P3
cmp P3, S1
