# n=5 model=out iset=I1 prefix14_class=3496
cmp P1, P0
cmovge S2, P0
cmovle S2, P1
cmovle P1, P0
cmp P3, P2
cmovle P0, P3
cmovle P3, P2
cmovge P0, P2
mov S0, P0
cmp S2, S0
cmovg S0, S2
cmovg S2, P0
cmp P1, P3
cmovle S1, P1
