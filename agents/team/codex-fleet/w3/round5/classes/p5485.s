# n=5 model=out iset=I1 prefix14_class=5485
cmp P3, P2
mov S1, P2
mov S0, P1
cmovl P2, P3
cmovl P3, S1
cmp P1, P0
mov S2, P2
cmovl S0, P0
cmovge P1, P0
cmp P2, P1
cmovl S2, P1
cmovl P1, P2
cmp P3, S0
cmovge S1, P3
