# n=5 model=out iset=I1 prefix14_class=13230
cmp P3, P1
cmovl S0, P1
cmovl P1, P3
mov S1, P0
cmovl P3, S0
cmp P0, P2
cmovg P0, P2
cmovl S1, P2
cmp P1, P0
cmovl S0, P0
cmovl P0, P1
mov S2, P3
cmovl P1, S0
cmp S2, S1
