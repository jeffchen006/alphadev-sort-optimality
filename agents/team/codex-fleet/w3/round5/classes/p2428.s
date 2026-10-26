# n=5 model=out iset=I1 prefix14_class=2428
mov S2, P0
mov S1, P1
cmp P2, S2
cmovge S2, P2
cmovle P0, P2
cmp S1, P3
cmovle S1, P3
cmovle P3, P1
mov P2, S2
cmp S1, S2
cmovge P2, S1
mov P2, P0
cmovge S1, S2
cmp P3, P2
