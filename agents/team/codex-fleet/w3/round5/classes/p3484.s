# n=5 model=out iset=I1 prefix14_class=3484
cmp P3, P1
mov S1, P1
cmovge P1, P3
cmovge P3, S1
mov S1, P3
mov S2, P0
cmp S2, P2
cmovle P0, P2
cmovle P2, S2
cmp P2, P3
cmovge P3, P2
cmovge P2, S1
cmp P0, P1
mov P2, P0
