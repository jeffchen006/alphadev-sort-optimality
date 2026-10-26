# n=5 model=out iset=I1 prefix14_class=12712
cmp P1, P0
cmovge S1, P0
cmovg P0, P1
cmovg P1, S1
cmp P2, P3
cmovl S1, P2
cmovl P2, P3
cmovl P3, S1
cmp P3, P1
cmovge S2, P1
mov S0, P0
cmovge P1, P3
cmovg P3, S2
cmp P0, P2
