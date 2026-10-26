# n=5 model=out iset=I1 prefix14_class=239
cmp P0, P2
mov S1, P0
cmovle S1, P2
cmovle P2, P0
cmp P1, P3
mov S2, P1
cmovge S2, P3
cmovge P3, P1
mov P0, P2
cmp S2, P2
cmovle P0, S2
cmovg P2, S2
mov S2, P2
cmp S1, P3
