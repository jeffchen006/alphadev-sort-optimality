# n=5 model=out iset=I1 prefix14_class=4156
cmp P0, P2
mov S2, P3
mov S0, P0
cmovge S0, P2
cmovg P2, P0
cmp P3, P1
cmovl S2, P1
cmovl P1, P3
cmp P1, S0
mov P3, S0
cmovge S0, P1
cmovl P3, P1
cmp P2, S2
cmovge S1, P2
