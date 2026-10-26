# n=5 model=out iset=I1 prefix14_class=11941
mov S2, P2
cmp P2, P0
cmovl S2, P0
cmovl P0, P2
mov S1, P3
cmp P3, P1
cmovl P3, P1
cmovl P1, S1
cmp S2, P3
cmovg S1, S2
cmovg S2, P3
cmovg P3, S1
cmp P1, P0
mov P3, P1
