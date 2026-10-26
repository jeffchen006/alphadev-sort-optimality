# n=5 model=out iset=I1 prefix14_class=12867
cmp P0, P1
cmovl S0, P1
cmovl P1, P0
mov S2, P2
cmovl P0, S0
cmp P3, S2
cmovl S2, P3
cmovl P3, P2
cmp S2, P1
mov S1, S2
cmovg S1, P1
cmovl S2, P1
mov S1, S2
cmp P0, P3
