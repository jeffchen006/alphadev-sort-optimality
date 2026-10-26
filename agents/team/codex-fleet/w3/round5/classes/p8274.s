# n=5 model=out iset=I1 prefix14_class=8274
cmp P3, P0
cmovl S1, P0
cmovl P0, P3
cmovl P3, S1
cmp P1, P2
cmovge S1, P2
cmovg P2, P1
cmovl S1, P1
cmp P0, S1
cmovg S2, P0
cmovg P0, S1
mov S0, P3
cmovg S1, S2
cmp P2, S0
