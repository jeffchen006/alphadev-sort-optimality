# n=5 model=out iset=I1 prefix14_class=3932
mov S2, P3
cmp P0, S2
cmovl S2, P0
cmovg P3, P0
mov P0, P1
cmp P2, P1
mov S1, S2
cmovl P0, P2
cmovg P1, P2
cmp S2, P0
cmovl S1, P0
cmovl P0, S2
mov P0, P1
cmp P1, P3
