# n=5 model=out iset=I1 prefix14_class=14112
mov S2, P0
cmp P2, P1
mov S0, P1
cmovle S0, P2
cmovle P2, P1
cmp P3, S2
cmovge P0, P3
cmovle S2, P3
cmp P2, P0
cmovle S1, P2
cmovle P2, P0
cmovle P0, S1
mov P2, S2
cmp S0, S2
