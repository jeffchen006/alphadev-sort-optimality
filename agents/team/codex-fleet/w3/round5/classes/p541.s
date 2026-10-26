# n=5 model=out iset=I1 prefix14_class=541
cmp P0, P1
mov S1, P0
mov S2, P3
cmovge S1, P1
cmovg P1, P0
cmp P3, P2
cmovge P3, P2
cmovge P2, S2
mov S0, P3
cmp S1, S0
mov S2, P1
cmovge S0, S1
cmovge S1, P3
cmp P2, S2
