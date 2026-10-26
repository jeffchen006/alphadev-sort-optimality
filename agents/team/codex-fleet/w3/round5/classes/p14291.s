# n=5 model=out iset=I1 prefix14_class=14291
mov S1, P1
cmp P3, P0
cmovge S0, P0
cmovge P0, P3
cmovg P3, S0
cmp S1, P2
cmovl S1, P2
cmovge P1, P2
mov S2, P3
cmp P1, S2
cmovge S2, P1
cmovl P3, P1
cmp P0, S1
cmovge P1, P0
