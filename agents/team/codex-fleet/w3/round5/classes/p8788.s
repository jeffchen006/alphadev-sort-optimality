# n=5 model=out iset=I1 prefix14_class=8788
cmp P0, P1
mov S0, P2
mov S2, P0
cmovle P0, P1
cmovge S2, P1
cmp P3, P2
cmovle S0, P3
cmovg P2, P3
cmp P0, P2
cmovge P1, P0
mov S1, S2
cmovge P0, P2
cmovge P2, P1
cmp S2, S0
