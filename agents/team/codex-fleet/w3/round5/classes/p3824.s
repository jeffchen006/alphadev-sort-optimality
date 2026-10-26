# n=5 model=out iset=I1 prefix14_class=3824
cmp P1, P2
mov S2, P1
cmovge S2, P2
cmovg P2, P1
cmp P3, P0
cmovl P1, P0
cmovl P0, P3
cmovge P1, P3
cmp P0, S2
cmovl P3, S2
cmovge P3, P0
cmovl S2, P0
cmp P2, P1
cmovl P0, P1
