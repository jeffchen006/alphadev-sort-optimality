# n=5 model=out iset=I1 prefix14_class=11312
mov S2, P3
cmp S2, P1
cmovge S2, P1
cmovl P3, P1
cmp P2, P0
cmovge P1, P2
cmovge P2, P0
mov S1, P2
cmovge P0, P1
cmp P0, P3
cmovge S0, P0
cmovge P0, P3
cmovge P3, S0
cmp S1, S2
