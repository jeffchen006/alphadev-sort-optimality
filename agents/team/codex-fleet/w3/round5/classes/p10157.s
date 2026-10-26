# n=5 model=out iset=I1 prefix14_class=10157
cmp P1, P2
mov S1, P3
cmovge S0, P1
cmovge P1, P2
cmovge P2, S0
cmp P0, S1
cmovge S1, P0
cmovge P0, P3
mov S2, S1
cmp P2, S2
cmovge S2, P2
cmovl S1, P2
mov S2, P0
cmp S2, P1
