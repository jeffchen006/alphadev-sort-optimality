# n=5 model=out iset=I1 prefix14_class=14472
cmp P2, P0
cmovg S1, P2
cmovg P2, P0
mov S0, P1
cmovg P0, S1
cmp P1, P3
cmovl S0, P3
cmovg P1, P3
mov S2, P2
cmp P1, S2
cmovl P2, P1
cmovl P1, S2
cmovge S2, P1
cmp P0, S0
