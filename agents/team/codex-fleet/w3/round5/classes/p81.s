# n=5 model=out iset=I1 prefix14_class=81
mov S1, P1
cmp P2, P0
mov S0, P0
cmovg P0, P2
cmovge P2, S0
cmp P3, S1
cmovge S1, P3
cmovge P3, P1
cmp P3, P2
cmovge P1, P3
mov S2, S1
cmovge P3, P2
cmovge P2, P1
cmp S2, P0
