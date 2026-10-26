# n=5 model=out iset=I1 prefix14_class=3203
mov S2, P3
cmp P0, S2
cmovl P3, P0
cmovge S2, P0
cmp P1, P2
cmovge S1, P2
cmovge P2, P1
cmovl S1, P1
mov P1, S1
cmp P3, S1
cmovg P1, P3
cmovg P3, S1
cmp P2, S2
cmovge P0, P2
