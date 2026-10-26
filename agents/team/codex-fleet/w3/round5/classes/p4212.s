# n=5 model=out iset=I1 prefix14_class=4212
cmp P2, P0
mov S2, P1
mov S1, P0
cmovl P0, P2
cmovge S1, P2
cmp P1, P3
cmovl P1, P3
cmovl P3, S2
mov S2, P0
cmp P3, P0
cmovge P0, P3
cmovl S2, P3
cmp P1, S1
cmovg P3, P1
