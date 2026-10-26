# n=5 model=out iset=I1 prefix14_class=2225
mov S2, P1
cmp P3, P0
mov S0, P0
cmovge P0, P3
cmovge P3, S0
cmp P2, S2
cmovge S2, P2
mov S1, S2
cmovge P2, P1
cmp S1, P0
cmovle S1, P0
mov S1, P3
cmovle P0, S2
cmp P2, S1
