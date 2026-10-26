# n=5 model=out iset=I1 prefix14_class=14125
mov S0, P3
cmp P1, P2
cmovge S2, P1
cmovge P1, P2
cmovge P2, S2
cmp P0, S0
cmovl P3, P0
cmovge S0, P0
cmp S0, P2
cmovl S1, S0
cmovl S0, P2
cmovl P2, S1
mov P0, P3
cmp P1, P0
