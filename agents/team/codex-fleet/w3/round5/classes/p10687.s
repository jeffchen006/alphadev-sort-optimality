# n=5 model=out iset=I1 prefix14_class=10687
mov S2, P2
cmp P0, P2
cmovl P2, P0
cmovl P0, S2
mov S0, P1
cmp S0, P3
mov S1, P0
cmovl P1, P3
cmovge S0, P3
cmp P1, P0
cmovl P0, P1
cmovge S1, P1
cmp P2, S0
cmovl S2, P2
