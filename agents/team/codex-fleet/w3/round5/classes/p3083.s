# n=5 model=out iset=I1 prefix14_class=3083
cmp P1, P2
cmovge S2, P2
cmovge P2, P1
cmovge P1, S2
cmp P3, P0
cmovl S0, P3
cmovge S0, P0
cmovl P3, P0
mov P0, P2
cmp S0, P1
mov S1, S0
cmovge S0, P1
cmovge P1, S1
cmp P3, P2
