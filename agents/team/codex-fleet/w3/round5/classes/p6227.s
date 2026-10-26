# n=5 model=out iset=I1 prefix14_class=6227
cmp P0, P3
cmovge S2, P3
cmovl S2, P0
cmovl P0, P3
cmp P1, P2
mov S0, P0
mov P3, P1
cmovl P3, P2
cmovg P1, P2
cmp P3, S0
cmovge P0, P3
cmovge P3, S0
cmp P1, S2
cmovge S1, S2
