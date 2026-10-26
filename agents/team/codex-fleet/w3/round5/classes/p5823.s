# n=5 model=out iset=I1 prefix14_class=5823
cmp P0, P1
cmovg S1, P1
cmovle S1, P0
cmovg P1, P0
cmp P2, P3
cmovle S2, P2
cmovle P2, P3
mov S0, S1
cmovle P3, S2
cmp S1, P3
cmovge S1, P3
cmovle S0, P3
mov P3, P1
cmp P3, P2
