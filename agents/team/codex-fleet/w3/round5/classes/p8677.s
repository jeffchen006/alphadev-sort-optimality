# n=5 model=out iset=I1 prefix14_class=8677
cmp P1, P3
cmovl S1, P1
cmovge S1, P3
cmovle P1, P3
cmp P2, P0
cmovl S2, P0
mov P3, P1
cmovl P0, P2
cmovl P2, S2
cmp P2, P3
cmovge P1, P2
cmovge P2, P3
cmp P0, S1
cmovge S2, S1
