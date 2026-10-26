# n=5 model=out iset=I1 prefix14_class=8727
cmp P0, P2
cmovl S1, P2
cmovge S1, P0
cmovg P0, P2
cmp P1, P3
cmovl P2, P1
mov S0, S1
cmovl P1, P3
cmovl P3, P2
cmp P1, S0
cmovl S1, P1
mov S2, P0
cmovge S0, P1
cmp P0, P3
