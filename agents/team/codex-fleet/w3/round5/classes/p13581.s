# n=5 model=out iset=I1 prefix14_class=13581
cmp P3, P2
mov S1, P2
cmovle S1, P3
cmovge P2, P3
cmp P0, P1
cmovge S2, P1
cmovge P1, P0
cmovle S2, P0
cmp S1, S2
cmovg P0, S2
cmovg S2, S1
cmovg S1, P0
cmp P2, P1
cmovle P3, P2
