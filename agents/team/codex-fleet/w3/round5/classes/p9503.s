# n=5 model=out iset=I1 prefix14_class=9503
mov S1, P2
mov S2, P3
cmp P3, P0
cmovle S2, P0
cmovge P3, P0
cmp P1, S1
cmovge P2, P1
cmovge P1, S1
cmp P1, P3
cmovg P0, P3
cmovge P3, P1
cmovle P0, P1
cmp S2, P2
cmovle P1, S2
