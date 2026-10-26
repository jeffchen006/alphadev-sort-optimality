# n=5 model=out iset=I1 prefix14_class=8425
mov S0, P1
mov S1, P0
cmp S1, P2
cmovge S1, P2
cmovge P2, P0
cmp P1, P3
cmovge S0, P3
cmovg P3, P1
cmp P3, P2
cmovge P1, P2
cmovge P2, P3
cmovg P3, P1
cmp S0, S1
mov S2, P3
