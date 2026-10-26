# n=5 model=out iset=I1 prefix14_class=3093
cmp P2, P3
cmovg S1, P2
mov S0, P0
cmovge P2, P3
cmovle S1, P3
cmp P1, S0
cmovle P0, P1
mov S2, P0
cmovle P1, S0
cmp S2, P2
cmovle S2, P2
cmovge P0, P2
mov P0, S1
cmp P0, P1
