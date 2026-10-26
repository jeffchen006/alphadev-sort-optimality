# n=5 model=out iset=I1 prefix14_class=2083
cmp P1, P3
mov S2, P3
cmovle S2, P1
cmovge P3, P1
cmp P2, P0
cmovge P1, P2
cmovge P2, P0
cmovge P0, P1
cmovle P1, P0
cmp P0, P3
cmovle P0, P3
cmovge P1, P3
cmp P2, S2
cmovge S1, S2
