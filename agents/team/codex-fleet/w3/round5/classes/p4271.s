# n=5 model=out iset=I1 prefix14_class=4271
cmp P2, P3
cmovge S1, P2
cmovge P2, P3
cmovl S1, P3
cmp P0, P1
cmovge S2, P0
cmovg P0, P1
cmovg P1, S2
cmp P0, P2
cmovge P3, P0
cmovl P3, P2
cmovl P2, P0
cmovl P0, P3
cmp S1, P1
