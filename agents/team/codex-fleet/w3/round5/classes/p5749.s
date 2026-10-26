# n=5 model=out iset=I1 prefix14_class=5749
cmp P2, P3
cmovg S1, P2
cmovge P2, P3
cmovle S1, P3
cmp P1, P0
cmovle P3, P1
cmovge P3, P0
cmovge P0, P1
cmp P2, P3
mov S2, P3
cmovle P3, P2
cmovle P2, S2
cmp S1, P0
cmovg S2, P2
