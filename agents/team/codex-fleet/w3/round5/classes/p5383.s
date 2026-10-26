# n=5 model=out iset=I1 prefix14_class=5383
cmp P1, P0
mov S1, P3
cmovle S0, P0
cmovle P0, P1
cmovle P1, S0
cmp S1, P2
cmovg S1, P2
cmovle P3, P2
cmp S1, P0
cmovge S2, P0
cmovle S2, S1
cmovge P0, S1
mov P2, P1
cmp P3, P2
