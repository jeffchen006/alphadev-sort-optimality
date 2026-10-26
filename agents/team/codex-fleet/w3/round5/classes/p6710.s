# n=5 model=out iset=I1 prefix14_class=6710
cmp P1, P3
mov S1, P1
cmovg P1, P3
cmovl S1, P3
cmp P2, P0
cmovl P3, P0
cmovl P0, P2
cmovge P3, P2
cmp P3, S1
cmovl S0, S1
cmovge S0, P3
cmovl S1, P3
cmp P0, P1
cmovge P3, P1
