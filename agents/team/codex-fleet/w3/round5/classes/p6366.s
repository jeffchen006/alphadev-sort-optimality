# n=5 model=out iset=I1 prefix14_class=6366
cmp P1, P2
cmovge S1, P1
cmovge P1, P2
cmovge P2, S1
mov S0, P0
cmp P3, S0
cmovl S0, P3
cmovge P0, P3
cmp P0, P2
cmovge S2, P2
cmovl S2, P0
cmovge P2, P0
mov P0, S0
cmp P1, S0
