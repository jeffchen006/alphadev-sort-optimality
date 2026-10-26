# n=5 model=out iset=I1 prefix14_class=4702
mov S2, P3
cmp P2, S2
mov S1, P1
cmovge P3, P2
cmovle S2, P2
cmp S1, P0
cmovle P1, P0
cmovge S1, P0
cmp P3, P1
cmovge P0, P1
cmovge P1, P3
cmovge P3, P0
cmp S2, S1
cmovle P1, S2
