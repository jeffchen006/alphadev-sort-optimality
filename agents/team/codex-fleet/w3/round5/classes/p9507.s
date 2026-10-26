# n=5 model=out iset=I1 prefix14_class=9507
cmp P1, P0
mov S1, P2
cmovl S0, P1
cmovl P1, P0
cmovl P0, S0
cmp P2, P3
cmovge S1, P3
cmovg P3, P2
cmp S1, P0
mov S2, S1
cmovge S2, P0
cmovl S1, P0
mov P0, S1
mov P2, P1
