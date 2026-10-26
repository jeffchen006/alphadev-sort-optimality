# n=5 model=out iset=I1 prefix14_class=13149
cmp P3, P1
cmovge S1, P1
cmovl S1, P3
mov S2, P2
cmovl P3, P1
cmp P2, P0
cmovl S2, P0
cmovg P2, P0
cmp P2, S1
cmovge P0, P2
cmovge P2, S1
cmovge S1, P0
cmp P3, S2
cmovl S0, S2
