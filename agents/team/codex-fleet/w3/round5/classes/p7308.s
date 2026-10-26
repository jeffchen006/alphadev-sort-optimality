# n=5 model=out iset=I1 prefix14_class=7308
cmp P0, P1
cmovl S0, P1
cmovl P1, P0
cmovl P0, S0
mov S2, P2
cmp P3, P2
cmovl S2, P3
cmovl P3, P2
cmp P1, S2
cmovge S1, P1
cmovge P1, S2
mov P1, P3
cmovge S2, S1
mov P2, S2
