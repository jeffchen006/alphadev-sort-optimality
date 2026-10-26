# n=5 model=out iset=I1 prefix14_class=2413
cmp P2, P3
cmovg S1, P2
cmovge P2, P3
cmovle S1, P3
mov S2, S1
mov S0, P0
cmp P1, S0
cmovle P0, P1
cmovge S0, P1
cmp S1, S0
cmovge S1, S0
cmovle S2, S0
cmp P2, P0
cmovle P3, P0
