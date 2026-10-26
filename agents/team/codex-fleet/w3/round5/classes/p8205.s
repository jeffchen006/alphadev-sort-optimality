# n=5 model=out iset=I1 prefix14_class=8205
cmp P2, P1
cmovge S2, P1
cmovle S2, P2
cmovle P2, P1
mov P1, P0
cmp P0, P3
cmovle P0, P3
cmovle P3, P1
cmovge P1, P3
cmp S2, P3
cmovge P1, S2
cmovge S2, P3
cmp P2, P0
cmovge S2, P0
