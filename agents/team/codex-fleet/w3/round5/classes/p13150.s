# n=5 model=out iset=I1 prefix14_class=13150
cmp P1, P3
cmovge S1, P3
cmovl S1, P1
mov S2, P2
cmovl P1, P3
cmp P2, P0
cmovl S2, P0
cmovg P2, P0
cmp P2, S1
cmovge P0, P2
cmovge P2, S1
cmovge S1, P0
cmp P1, S2
cmovl S0, S2
