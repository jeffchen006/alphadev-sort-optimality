# n=5 model=out iset=I1 prefix14_class=7427
mov S1, P0
mov S2, P1
cmp P3, P0
cmovge S1, P3
cmovge P3, P0
cmp P2, P1
cmovg S2, P2
cmovg P2, P1
cmp P3, P2
cmovge P1, P3
cmovg P3, P2
cmovge P2, P1
cmp S1, S2
cmovg P0, S1
