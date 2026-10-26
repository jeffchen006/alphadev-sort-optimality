# n=5 model=out iset=I1 prefix14_class=7068
mov S2, P0
cmp P2, P0
cmovge S2, P2
cmovg P2, P0
cmp P1, P3
cmovge P0, P1
mov S1, P2
cmovge P1, P3
cmovg P3, P0
cmp S1, P1
cmovle S1, P1
cmovle P1, P2
cmp S2, P3
mov P2, S2
