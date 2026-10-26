# n=5 model=out iset=I1 prefix14_class=671
mov S0, P2
cmp P0, S0
cmovl P2, P0
cmovl P0, S0
mov S1, P3
cmp P3, P1
cmovg P3, P1
mov S0, P0
cmovl S1, P1
cmp S0, S1
cmovl P0, S1
cmovl S1, S0
cmp P2, P3
cmovl S0, P2
