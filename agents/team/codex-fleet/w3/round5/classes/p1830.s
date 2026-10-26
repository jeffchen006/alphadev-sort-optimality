# n=5 model=out iset=I1 prefix14_class=1830
cmp P2, P0
cmovge S2, P0
cmovg P0, P2
cmovg P2, S2
mov S1, P3
cmp P1, S1
cmovge P3, P1
cmovge P1, S1
cmp P3, P0
cmovl S0, P3
cmovge S0, P0
cmovl P3, P0
cmp P1, P2
cmovge P0, P2
