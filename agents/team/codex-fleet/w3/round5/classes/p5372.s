# n=5 model=out iset=I1 prefix14_class=5372
cmp P0, P2
mov S1, P3
mov S2, P0
cmovl S2, P2
cmovl P2, P0
cmp P1, S1
cmovl S1, P1
mov S0, P2
cmovl P1, P3
cmp S1, P2
cmovl P2, S1
cmovg S0, S1
cmp S2, P1
cmovl P0, S2
