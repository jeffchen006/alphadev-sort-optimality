# n=5 model=out iset=I1 prefix14_class=7488
mov S1, P3
cmp P3, P0
cmovl P3, P0
cmovl P0, S1
cmp P2, P1
mov S1, P0
cmovge S2, P2
cmovge P2, P1
cmovl S2, P1
cmp P2, P0
cmovg P0, P2
cmovl S1, P2
cmp P3, S2
cmovge S0, P3
