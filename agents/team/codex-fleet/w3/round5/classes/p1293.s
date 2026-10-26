# n=5 model=out iset=I1 prefix14_class=1293
cmp P1, P3
cmovg S1, P3
mov S0, P2
cmovg P3, P1
cmovg P1, S1
mov S2, P3
cmp S0, P0
cmovle P2, P0
cmovle P0, S0
cmp P3, P2
cmovle S2, P2
cmovg P3, P2
cmp P1, P0
cmovge S2, P1
