# n=5 model=out iset=I1 prefix14_class=6168
cmp P2, P3
cmovge S1, P2
mov S0, P1
cmovl S1, P3
cmovge P2, P3
cmp P0, P1
cmovge S0, P0
cmovl P1, P0
mov P0, P1
cmp S1, S0
cmovge S2, S0
cmovge S0, S1
cmovge S1, S2
cmp P2, P0
