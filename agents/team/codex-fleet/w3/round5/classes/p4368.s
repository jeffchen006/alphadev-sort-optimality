# n=5 model=out iset=I1 prefix14_class=4368
cmp P1, P2
cmovl S0, P1
cmovl P1, P2
cmovge S0, P2
mov S1, P3
cmp P0, P3
cmovl S1, P0
cmovl P0, P3
cmp S1, S0
mov P2, P0
cmovl P3, S1
cmovl S1, S0
cmovl S0, P3
cmp P0, P1
