# n=5 model=out iset=I1 prefix14_class=8428
cmp P0, P2
cmovg S1, P0
cmovg P0, P2
mov S2, P1
cmovg P2, S1
cmp S2, P3
cmovge S2, P3
cmovge P3, P1
mov P1, P2
cmp P3, P2
cmovge P2, P3
cmovge P3, P1
cmp S2, P0
mov P1, P0
