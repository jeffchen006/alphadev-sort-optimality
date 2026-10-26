# n=5 model=out iset=I1 prefix14_class=82
mov S1, P1
cmp P2, P0
cmovge S0, P0
cmovge P0, P2
cmovge P2, S0
cmp P3, S1
cmovge S1, P3
cmovg P3, P1
cmp P3, P2
mov P1, P3
mov S2, S1
cmovge P3, P2
cmovge P2, P1
cmp S1, P0
