# n=5 model=out iset=I1 prefix14_class=953
cmp P0, P2
cmovl S2, P2
cmovl P2, P0
cmovge S2, P0
mov S0, S2
cmp P3, P1
cmovge S1, P3
cmovg P3, P1
cmovge P1, S1
cmp P1, S0
cmovge S2, P1
cmovge P1, S0
cmp P3, P2
cmovl S1, P3
