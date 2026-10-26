# n=5 model=out iset=I1 prefix14_class=6293
mov S1, P3
mov S2, P1
cmp P2, S2
cmovl P1, P2
cmovg S2, P2
cmp P0, S1
cmovge P3, P0
cmovge P0, S1
mov P2, S2
cmp S2, P3
cmovl P2, P3
cmovl P3, S2
cmp P0, P1
cmovl S2, P0
