# n=5 model=out iset=I1 prefix14_class=5300
cmp P2, P1
mov S2, P2
cmovge P2, P1
cmovge P1, S2
mov S1, P0
cmp S1, P3
cmovge P0, P3
mov S2, P0
cmovle S1, P3
cmp P0, P2
cmovle S2, P2
cmovle P2, P0
cmp S1, P1
cmovg P0, S1
