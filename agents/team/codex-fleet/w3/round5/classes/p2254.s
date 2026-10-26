# n=5 model=out iset=I1 prefix14_class=2254
cmp P3, P0
mov S2, P0
cmovge S2, P3
cmovge P3, P0
cmp P1, P2
cmovge S0, P2
cmovge P2, P1
cmovge P1, S0
mov S1, S2
cmp S1, P2
cmovle S1, P2
mov S1, P3
cmovle P2, S2
cmp P3, P1
