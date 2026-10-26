# n=5 model=out iset=I1 prefix14_class=7417
cmp P1, P3
mov S2, P0
mov S1, P3
cmovg S1, P1
cmovg P1, P3
cmp P2, P0
cmovg S2, P2
cmovg P2, P0
cmp P1, P2
cmovge P0, P1
cmovg P1, P2
cmovge P2, P0
cmp S2, S1
mov P1, S1
