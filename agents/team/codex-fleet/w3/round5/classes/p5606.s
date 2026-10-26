# n=5 model=out iset=I1 prefix14_class=5606
mov S1, P2
cmp S1, P0
cmovg S1, P0
cmovl P2, P0
cmovl P0, S1
cmp P1, P3
cmovl S0, P1
cmovl P1, P3
cmovl P3, S0
cmp S1, P3
cmovg S1, P3
cmovg P3, P0
cmp P2, P1
mov S1, P1
