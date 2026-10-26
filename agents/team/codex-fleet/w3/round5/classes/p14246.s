# n=5 model=out iset=I1 prefix14_class=14246
cmp P1, P0
mov S2, P3
cmovg S1, P0
cmovg P0, P1
cmovg P1, S1
cmp P2, S2
cmovl P3, P2
cmovge S2, P2
mov S0, S2
cmp P0, S0
cmovge S2, P0
cmovl S0, P0
mov S2, P3
cmp P1, S2
