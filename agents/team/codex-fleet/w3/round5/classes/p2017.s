# n=5 model=out iset=I1 prefix14_class=2017
cmp P2, P1
mov S1, P1
cmovg P1, P2
cmovge P2, S1
cmp P0, P3
cmovl S2, P0
cmovl P0, P3
cmovge S2, P3
cmovg P3, P0
cmp P1, P0
cmovg P0, P1
cmovge P1, P3
mov P3, S2
cmp P2, S2
