# n=5 model=out iset=I1 prefix14_class=7432
mov S1, P0
cmp P2, P0
mov S2, P3
cmovg S1, P2
cmovg P2, P0
cmp P1, P3
cmovg S2, P1
cmovge P1, P3
cmp P2, P1
mov P0, S2
cmovg P3, P2
cmovge P2, P1
cmovg P1, P3
cmp S2, S1
