# n=5 model=out iset=I1 prefix14_class=4709
cmp P2, P3
mov S2, P1
mov S0, P3
cmovle S0, P2
cmovle P2, P3
cmp P1, P0
cmovge P1, P0
mov S1, P2
cmovle S2, P0
cmp S2, S1
cmovge S1, S2
cmovge S2, P2
cmp P1, S0
cmovge P0, P1
