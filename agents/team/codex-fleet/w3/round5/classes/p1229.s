# n=5 model=out iset=I1 prefix14_class=1229
cmp P0, P3
cmovl S1, P0
cmovl P0, P3
cmovl P3, S1
cmp P1, P2
mov S2, P1
cmovge P1, P2
cmovl S2, P2
cmp P0, S2
cmovge S0, P0
cmovg P0, S2
cmovg S2, S0
cmp P3, P1
cmovge S0, P3
