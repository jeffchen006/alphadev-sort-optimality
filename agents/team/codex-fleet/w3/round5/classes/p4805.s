# n=5 model=out iset=I1 prefix14_class=4805
mov S2, P3
cmp P1, S2
cmovg P3, P1
cmovle S2, P1
cmp P2, P0
cmovg S1, P2
cmovge P2, P0
cmovg P0, S1
cmp S2, P2
cmovle P1, P2
cmovge P1, S2
cmovle P2, S2
cmp P3, P0
mov P2, P0
