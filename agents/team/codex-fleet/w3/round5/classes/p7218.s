# n=5 model=out iset=I1 prefix14_class=7218
mov S1, P2
cmp P2, P3
cmovge S1, P3
mov S0, S1
cmovg P3, P2
cmp P0, P1
cmovle S2, P1
cmovg S2, P0
cmovge P0, P1
cmp P0, S0
cmovle S1, P0
cmovle P0, S0
cmp S2, P3
cmovle S0, P3
