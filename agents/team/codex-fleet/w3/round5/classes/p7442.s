# n=5 model=out iset=I1 prefix14_class=7442
cmp P2, P1
cmovge S0, P2
mov S2, P0
cmovge P2, P1
mov S1, P2
cmovl S0, P1
cmp P0, P3
cmovge P0, P3
cmovg P3, S2
cmp S1, P0
cmovl P1, S0
cmovge S1, P0
cmovge P0, P2
cmp P3, S0
