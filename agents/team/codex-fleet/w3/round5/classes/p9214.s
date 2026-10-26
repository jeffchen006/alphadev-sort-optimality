# n=5 model=out iset=I1 prefix14_class=9214
cmp P0, P3
cmovle S2, P0
cmovge S2, P3
cmovle P0, P3
mov S1, P1
cmp P2, P1
cmovge P1, P2
cmovle S1, P2
cmp S2, S1
cmovge P2, S2
mov S0, P0
cmovg S2, S1
cmovg S1, P2
cmp P1, P0
