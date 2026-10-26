# n=5 model=out iset=I1 prefix14_class=9519
cmp P3, P2
cmovg S2, P2
cmovle S2, P3
mov S1, P0
cmovle P3, P2
cmp S1, P1
cmovg P0, P1
cmovg P1, S1
cmp S2, P0
cmovge P2, S2
cmovg S2, P0
mov S2, P3
cmovg P0, P2
cmp S2, P1
