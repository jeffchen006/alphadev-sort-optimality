# n=5 model=out iset=I1 prefix14_class=6645
cmp P3, P2
mov S2, P2
cmovge S2, P3
cmovge P3, P2
cmp P1, P0
cmovge S1, P0
cmovge P0, P1
cmovg P1, S1
cmp S2, P0
cmovl P2, S2
cmovl S2, P0
cmovge P2, P0
cmp P3, P1
cmovl S2, P1
