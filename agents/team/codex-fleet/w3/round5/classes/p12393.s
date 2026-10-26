# n=5 model=out iset=I1 prefix14_class=12393
mov S0, P3
mov S1, P2
cmp P2, P1
cmovle P2, P1
cmovge S1, P1
cmp S0, P0
cmovg S0, P0
cmovle P3, P0
cmp S0, S1
cmovge S2, S1
cmovle S2, S0
cmovg S1, S0
cmp P3, P2
cmovle P0, P2
