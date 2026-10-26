# n=5 model=out iset=I1 prefix14_class=3277
mov S1, P1
cmp S1, P3
cmovge P1, P3
cmovg P3, S1
cmp P0, P2
cmovge S2, P2
cmovge P2, P0
cmovge P0, S2
mov S0, P0
cmp S0, P1
cmovg P0, P1
cmovge P1, S0
mov S0, P3
cmp S0, P2
