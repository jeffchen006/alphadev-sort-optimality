# n=5 model=out iset=I1 prefix14_class=9231
cmp P2, P1
mov S1, P3
cmovge S2, P1
cmovg P1, P2
cmovg P2, S2
mov S0, P2
cmp P0, S1
cmovg P3, P0
cmovl S1, P0
cmp P2, S1
cmovl P2, S1
mov P0, P2
cmovge S0, S1
cmp P3, P1
