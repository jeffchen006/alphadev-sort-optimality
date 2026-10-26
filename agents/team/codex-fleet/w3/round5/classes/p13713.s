# n=5 model=out iset=I1 prefix14_class=13713
cmp P2, P3
cmovge S0, P2
cmovle S0, P3
cmovle P3, P2
cmp P0, P1
mov S2, P3
cmovle S1, P0
cmovg S1, P1
cmovge P1, P0
cmp S2, S1
cmovle S2, S1
cmovle S1, P3
cmp P1, S0
cmovge P3, P1
