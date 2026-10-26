# n=5 model=out iset=I1 prefix14_class=4008
cmp P1, P3
cmovle S0, P1
mov S2, P2
cmovge S0, P3
cmovle P1, P3
cmp S2, P0
cmovge S2, P0
cmovge P0, P2
cmp S0, S2
mov S1, S0
cmovge S1, S2
cmovg S2, S0
cmp P0, P1
cmovle P3, P0
