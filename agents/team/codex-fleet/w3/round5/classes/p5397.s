# n=5 model=out iset=I1 prefix14_class=5397
cmp P3, P2
cmovl S2, P2
cmovge S2, P3
mov S1, P1
cmovg P3, P2
cmp P1, P0
cmovl P1, P0
cmovge S1, P0
cmovl P0, S1
cmp P0, P3
cmovg P0, P3
cmovge P3, S1
mov P0, P3
cmp S2, P1
