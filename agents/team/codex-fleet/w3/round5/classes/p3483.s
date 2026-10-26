# n=5 model=out iset=I1 prefix14_class=3483
mov S1, P1
cmp P3, S1
mov S2, P0
cmovg P1, P3
cmovge P3, S1
cmovle S1, P3
cmp S2, P2
cmovle P0, P2
cmovle P2, S2
cmp P2, S1
cmovg S1, P2
cmovg P2, P3
cmp P0, P1
cmovg P2, P0
