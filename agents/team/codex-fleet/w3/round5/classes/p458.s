# n=5 model=out iset=I1 prefix14_class=458
cmp P3, P1
cmovl S1, P1
cmovl P1, P3
cmovge S1, P3
cmp P2, P0
cmovge S2, P2
cmovg P2, P0
cmovge P0, S2
mov S0, S1
cmp P2, P1
mov P3, P1
cmovl P1, P2
cmovle P2, P3
mov P1, P2
