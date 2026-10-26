# n=5 model=out iset=I1 prefix14_class=7562
mov S0, P2
cmp S0, P0
cmovge S0, P0
mov S1, P3
cmovg P0, P2
cmp P3, P1
cmovl P3, P1
cmovg S1, P1
cmp S0, S1
cmovl P1, S0
cmovl S0, S1
cmovl S1, P1
cmp P0, P3
cmovg P1, P3
