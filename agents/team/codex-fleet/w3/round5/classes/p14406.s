# n=5 model=out iset=I1 prefix14_class=14406
mov S2, P2
mov S1, P3
cmp P0, S2
cmovle P2, P0
cmovle P0, S2
cmp S1, P1
cmovg S1, P1
cmovge P1, P3
cmp S1, P2
cmovge P3, S1
cmovge S1, P2
cmovge P2, P3
cmp P1, P0
mov S1, P0
