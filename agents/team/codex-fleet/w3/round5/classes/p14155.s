# n=5 model=out iset=I1 prefix14_class=14155
cmp P1, P3
mov S1, P0
cmovl S0, P3
cmovl P3, P1
cmovl P1, S0
cmp P2, P0
cmovge S1, P2
mov S2, S1
cmovg P2, P0
cmp S1, P1
cmovge S1, P1
cmovg P1, S2
mov P1, P2
cmp P2, P3
