# n=5 model=out iset=I1 prefix14_class=3284
cmp P1, P0
cmovge S2, P0
cmovge P0, P1
cmovg P1, S2
cmp P2, P3
cmovg S2, P3
cmovge P3, P2
mov S1, P1
cmovg P2, S2
cmp S1, P2
cmovge S1, P2
cmovg P2, P1
mov S0, P0
cmp P0, P3
