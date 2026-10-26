# n=5 model=out iset=I1 prefix14_class=7429
mov S1, P0
mov S2, P1
cmp P2, P0
cmovge S1, P2
cmovg P2, P0
cmp P3, P1
cmovg S2, P3
cmovg P3, P1
cmp P2, P3
cmovge P1, P2
cmovge P2, P3
cmovge P3, P1
cmp S2, S1
mov S0, S2
