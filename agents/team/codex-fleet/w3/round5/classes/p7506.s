# n=5 model=out iset=I1 prefix14_class=7506
mov S2, P1
cmp P3, P2
cmovg S0, P3
cmovge P3, P2
cmovg P2, S0
cmp P0, P1
cmovge S2, P0
cmovge P0, P1
cmp P0, P3
cmovg S1, P0
cmovle S1, P3
cmovle P3, P0
mov P1, S2
cmp S2, P2
