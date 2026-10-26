# n=5 model=out iset=I1 prefix14_class=62
mov S1, P1
cmp P0, P1
cmovl S1, P0
mov S2, P3
cmovl P0, P1
cmp P2, P3
mov P1, S1
cmovg P3, P2
cmovl S2, P2
cmp S1, S2
cmovge S1, S2
cmovg S2, P1
mov S1, P0
cmp S1, P3
