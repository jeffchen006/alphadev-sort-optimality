# n=5 model=out iset=I1 prefix14_class=9529
cmp P3, P1
cmovl S1, P1
cmovl P1, P3
cmovl P3, S1
cmp P0, P2
cmovge S0, P0
cmovl S0, P2
cmovg P0, P2
cmp P1, P0
mov S2, P1
cmovl P1, P0
mov P2, S0
cmovge S2, P0
cmovge P0, P1
