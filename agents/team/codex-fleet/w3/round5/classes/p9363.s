# n=5 model=out iset=I1 prefix14_class=9363
mov S2, P0
cmp P0, P3
cmovl P0, P3
cmovl P3, S2
cmp P2, P1
cmovl S0, P1
cmovl P1, P2
mov S1, P3
cmovl P2, S0
cmp P1, S1
cmovge P3, P1
cmovg P1, S1
mov P1, P2
cmovge S1, P3
