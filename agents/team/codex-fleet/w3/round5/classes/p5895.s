# n=5 model=out iset=I1 prefix14_class=5895
cmp P3, P0
cmovge S2, P0
mov S0, P1
cmovge P0, P3
cmovg P3, S2
cmp P2, S0
cmovle S0, P2
cmovle P2, P1
mov S2, P0
cmp P2, P0
cmovge P0, P2
cmovle S2, P2
cmp S0, P3
cmovle S1, S0
