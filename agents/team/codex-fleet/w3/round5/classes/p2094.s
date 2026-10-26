# n=5 model=out iset=I1 prefix14_class=2094
cmp P0, P3
cmovge S0, P3
cmovle S0, P0
cmovge P3, P0
mov S2, P1
cmp S2, P2
cmovle P1, P2
cmovg S2, P2
cmp P3, P1
cmovg S1, P3
cmovle S1, P1
cmovg P3, P1
cmp S0, S2
cmovle S1, S0
