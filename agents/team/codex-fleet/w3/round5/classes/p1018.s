# n=5 model=out iset=I1 prefix14_class=1018
mov S1, P2
cmp S1, P1
cmovle S1, P1
cmovle P1, P2
mov P2, S1
mov S2, P0
cmp P0, P3
cmovge S2, P3
cmovge P3, P0
cmp P3, P2
cmovge S1, P3
cmovge P3, P2
cmp P1, S2
mov S1, P1
