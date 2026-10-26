# n=5 model=out iset=I1 prefix14_class=11075
mov S1, P1
mov S2, P3
cmp P3, P0
cmovl S2, P0
cmovl P0, P3
cmp S1, P2
cmovl S1, P2
cmovl P2, P1
cmp S1, S2
cmovl P1, S2
cmovl S2, S1
cmovl S1, P1
cmp P0, P2
mov S1, P0
