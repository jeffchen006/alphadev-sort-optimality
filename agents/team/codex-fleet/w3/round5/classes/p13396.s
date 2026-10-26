# n=5 model=out iset=I1 prefix14_class=13396
cmp P0, P2
cmovge S2, P0
mov S1, P3
cmovg P0, P2
cmovge P2, S2
cmp P1, S1
cmovge P3, P1
cmovl S1, P1
mov P1, P0
cmp S1, P1
cmovl P1, S1
cmovl S1, P0
cmp P2, P3
cmovg P1, P2
