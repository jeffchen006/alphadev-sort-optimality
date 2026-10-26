# n=5 model=out iset=I1 prefix14_class=9853
cmp P3, P2
mov S2, P2
cmovge S2, P3
cmovl P2, P3
cmp P0, P1
cmovge P3, P1
cmovge P1, P0
mov S1, S2
cmovg P0, P3
cmp P1, S1
cmovl S2, P1
cmovl P1, S1
cmp P2, P0
mov P1, S2
