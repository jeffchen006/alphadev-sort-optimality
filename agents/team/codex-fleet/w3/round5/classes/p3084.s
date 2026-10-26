# n=5 model=out iset=I1 prefix14_class=3084
cmp P1, P2
cmovge S2, P2
cmovg P2, P1
cmovge P1, S2
cmp P3, P0
cmovge S1, P0
cmovl S1, P3
cmovl P3, P0
cmp S1, P1
cmovge P0, S1
cmovge S1, P1
mov S0, P2
cmovge P1, P0
cmp P3, S0
