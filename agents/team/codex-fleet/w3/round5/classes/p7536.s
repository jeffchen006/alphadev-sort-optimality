# n=5 model=out iset=I1 prefix14_class=7536
cmp P3, P1
cmovge S1, P1
cmovge P1, P3
cmovle S1, P3
cmp P2, P0
cmovge P3, P0
mov S2, S1
cmovg P0, P2
cmovg P2, P3
cmp S1, P2
cmovle S2, P2
cmovle P2, S1
cmp P0, P1
cmovle S1, P0
