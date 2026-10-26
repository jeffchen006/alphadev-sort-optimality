# n=5 model=out iset=I1 prefix14_class=9276
mov S2, P1
cmp P2, P1
cmovg S2, P2
cmovge P2, P1
mov P1, S2
cmp P0, P3
cmovge S1, P0
cmovg P0, P3
cmovge P3, S1
cmp P2, P0
cmovge S1, P0
cmovge P0, P2
cmovge P2, S1
cmp S2, P3
