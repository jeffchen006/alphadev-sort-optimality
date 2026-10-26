# n=5 model=out iset=I1 prefix14_class=5752
cmp P3, P2
cmovge S2, P2
cmovl S2, P3
cmovl P3, P2
cmovl P2, S2
mov S1, P1
cmp P1, P0
cmovge P1, P0
cmovge P0, S1
cmp P1, P2
cmovl S2, P1
cmovl P1, P2
cmp P3, P0
cmovl P2, P1
