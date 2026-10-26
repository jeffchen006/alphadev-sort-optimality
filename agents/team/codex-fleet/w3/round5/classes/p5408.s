# n=5 model=out iset=I1 prefix14_class=5408
cmp P1, P2
mov S1, P0
mov S2, P2
cmovg S2, P1
cmovg P1, P2
cmp P0, P3
cmovle S1, P3
cmovle P3, P0
mov P0, P3
cmp P0, P1
cmovge P3, P1
cmovge P1, P0
cmp S2, S1
cmovge P3, S2
