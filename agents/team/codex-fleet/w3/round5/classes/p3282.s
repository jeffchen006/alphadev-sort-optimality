# n=5 model=out iset=I1 prefix14_class=3282
cmp P1, P0
cmovg S2, P0
cmovge P0, P1
cmovg P1, S2
cmp P2, P3
cmovg S1, P3
cmovge P3, P2
cmovg P2, S1
mov S2, P1
cmp S2, P2
cmovg S2, P2
cmovg P2, P1
mov S2, P0
cmp P0, P3
