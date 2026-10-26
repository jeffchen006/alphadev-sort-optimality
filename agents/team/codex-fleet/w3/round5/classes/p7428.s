# n=5 model=out iset=I1 prefix14_class=7428
mov S1, P0
mov S2, P1
cmp P3, P0
cmovg S1, P3
cmovg P3, P0
cmp P2, P1
cmovg S2, P2
cmovg P2, P1
cmp P3, P2
cmovge P1, P3
cmovg P3, P2
cmovge P2, P1
cmp S2, S1
mov P0, S2
