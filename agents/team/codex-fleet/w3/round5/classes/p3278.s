# n=5 model=out iset=I1 prefix14_class=3278
mov S1, P1
cmp S1, P3
cmovg P1, P3
cmovg P3, S1
cmp P0, P2
cmovge S2, P2
cmovge P2, P0
cmovge P0, S2
mov S1, P0
cmp S1, P1
cmovg P0, P1
cmovge P1, S1
mov S1, P3
cmp S1, P2
