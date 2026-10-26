# n=5 model=out iset=I1 prefix14_class=7447
cmp P2, P1
mov S1, P3
mov S2, P1
cmovge P1, P2
cmovg P2, S2
cmp P3, P0
cmovg S1, P0
cmovge P0, P3
cmp P2, S1
cmovg P3, P2
cmovge P2, S1
mov S0, P0
cmovg S1, P3
cmp S0, P1
