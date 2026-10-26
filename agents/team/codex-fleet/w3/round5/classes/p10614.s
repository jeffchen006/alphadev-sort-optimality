# n=5 model=out iset=I1 prefix14_class=10614
cmp P2, P1
cmovl S0, P2
mov S1, P3
cmovl P2, P1
cmovl P1, S0
cmp P3, P0
cmovge S1, P0
cmovl P3, P0
cmp P2, P3
mov S2, P3
cmovl P3, P2
mov P0, P1
cmovl P2, S2
cmp S1, P1
