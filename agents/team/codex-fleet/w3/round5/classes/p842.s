# n=5 model=out iset=I1 prefix14_class=842
cmp P2, P1
mov S2, P1
mov S1, P3
cmovge S2, P2
cmovge P2, P1
cmp S1, P0
cmovg S1, P0
cmovg P0, P3
cmp P0, S2
mov P1, S2
cmovg S2, P0
cmovge P0, P1
cmp P2, S1
cmovge S2, P2
