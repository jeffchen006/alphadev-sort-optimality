# n=5 model=out iset=I1 prefix14_class=1121
cmp P3, P0
cmovge S2, P3
mov S0, P2
cmovle S2, P0
cmovle P0, P3
cmp P1, S0
cmovge S0, P1
cmovge P1, P2
cmovge P2, S0
cmp S0, S2
cmovle P2, S2
cmovle S2, S0
cmp P1, P0
cmovle S1, P0
