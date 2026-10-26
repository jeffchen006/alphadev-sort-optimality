# n=5 model=out iset=I1 prefix14_class=9585
cmp P2, P3
cmovle S2, P2
cmovle P2, P3
mov S1, P1
cmovle P3, S2
cmp P0, S1
cmovge S1, P0
cmovge P0, P1
cmp S1, P2
cmovg S0, P2
cmovle S0, S1
cmovge P2, S1
cmp P3, P0
cmovle P1, P0
