# n=5 model=out iset=I1 prefix14_class=2687
mov S2, P0
cmp P2, P1
cmovl S1, P2
cmovge S1, P1
cmovg P1, P2
cmp P0, P3
cmovg P0, P3
cmovl S2, P3
mov P3, P1
cmp P1, S2
cmovl P1, S2
cmovg P3, S2
cmp S1, P0
cmovg P2, S1
