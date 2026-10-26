# n=5 model=out iset=I1 prefix14_class=8273
cmp P3, P0
cmovl S1, P0
cmovl P0, P3
cmovl P3, S1
cmp P1, P2
cmovge S2, P2
cmovg P2, P1
cmovl S2, P1
cmp P0, S2
cmovg S1, P0
cmovg P0, S2
mov S0, P3
cmovg S2, S1
cmp P2, S0
