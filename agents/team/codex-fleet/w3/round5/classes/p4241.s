# n=5 model=out iset=I1 prefix14_class=4241
cmp P3, P1
mov S0, P1
cmovge P1, P3
cmovg P3, S0
mov S1, P0
cmp P2, P0
cmovge S1, P2
cmovge P2, P0
cmp P3, P2
mov S2, P3
cmovle S2, P2
cmovle P2, P3
cmp S1, P1
cmovge P3, P1
