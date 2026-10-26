# n=5 model=out iset=I1 prefix14_class=7382
mov S1, P3
cmp P3, P2
mov S0, P1
cmovle P3, P2
cmovle P2, S1
cmovle S1, P3
cmp S0, P0
cmovge P1, P0
cmovg P0, S0
cmp P1, P2
cmovge S2, P2
cmovg P2, P1
cmovge P1, S2
cmp P0, S1
