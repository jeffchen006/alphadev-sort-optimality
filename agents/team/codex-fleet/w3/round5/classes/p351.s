# n=5 model=out iset=I1 prefix14_class=351
cmp P2, P1
cmovge S1, P2
cmovg P2, P1
cmovge P1, S1
cmp P0, P3
cmovge S1, P0
mov S0, P1
cmovge P0, P3
cmovg P3, S1
cmp P0, P2
cmovge S1, P2
cmovl S1, P0
cmovl P0, P2
cmp P3, S0
