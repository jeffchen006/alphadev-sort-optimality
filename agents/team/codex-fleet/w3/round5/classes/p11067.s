# n=5 model=out iset=I1 prefix14_class=11067
cmp P3, P1
cmovl S0, P1
cmovge S0, P3
cmovl P1, P3
cmp P0, P2
cmovl P3, P0
cmovl P0, P2
cmovl P2, P3
cmp S0, P0
mov S1, P0
cmovl S1, S0
cmovg P0, S0
cmp P2, P1
cmovge S2, P2
