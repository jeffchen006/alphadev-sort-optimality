# n=5 model=out iset=I1 prefix14_class=6257
cmp P3, P0
cmovle S1, P0
cmovle P0, P3
cmovg S1, P3
mov S0, P1
cmp P2, P1
cmovge S0, P2
cmovle P1, P2
cmovg P2, P1
cmp S1, S0
cmovle S2, S0
cmovle S0, S1
cmovle S1, S2
cmp P2, P0
