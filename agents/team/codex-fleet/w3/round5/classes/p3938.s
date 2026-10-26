# n=5 model=out iset=I1 prefix14_class=3938
mov S0, P3
cmp P2, S0
cmovle S0, P2
cmovge P3, P2
mov S1, P1
cmp S1, P0
cmovle P1, P0
cmovg S1, P0
cmp S0, S1
cmovle S2, S1
cmovge S2, S0
cmovle S1, S0
cmp P3, P1
cmovge S0, P3
