# n=5 model=out iset=I1 prefix14_class=9173
cmp P2, P1
cmovl S2, P2
cmovge S2, P1
cmovge P1, P2
cmp P0, P3
mov P2, P3
cmovl P3, P0
cmovl P0, P2
cmp P3, S2
cmovge S0, P3
cmovg P3, S2
cmovge S2, S0
mov S1, P1
cmp P0, S1
