# n=5 model=out iset=I1 prefix14_class=10293
cmp P1, P3
cmovl S2, P1
cmovle P1, P3
cmovge S2, P3
cmp P2, P0
cmovge P3, P0
mov S1, P1
cmovge P0, P2
cmovge P2, P3
cmp P0, P1
cmovle P1, P0
cmovge S1, P0
cmp P2, S2
cmovge S1, S2
