# n=5 model=out iset=I1 prefix14_class=1741
mov S1, P3
cmp P3, P1
cmovl P3, P1
cmovl P1, S1
mov S1, P2
cmp P0, S1
mov S2, P1
cmovl S1, P0
cmovl P0, P2
cmp S2, S1
cmovl P1, S1
cmovge S2, S1
cmp P0, P3
cmovl P2, P3
