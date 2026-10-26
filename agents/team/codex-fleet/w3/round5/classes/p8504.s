# n=5 model=out iset=I1 prefix14_class=8504
cmp P0, P3
cmovl S1, P3
cmovl P3, P0
cmovl P0, S1
mov S2, P1
cmp S2, P2
cmovl S2, P2
cmovl P2, P1
mov P1, S2
cmp P0, S2
cmovge S2, P0
cmovl P1, P0
cmp P2, P3
cmovg S0, P3
