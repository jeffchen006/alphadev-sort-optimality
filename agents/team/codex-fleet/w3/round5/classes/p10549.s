# n=5 model=out iset=I1 prefix14_class=10549
mov S0, P3
cmp P2, P3
cmovge S0, P2
cmovle P3, P2
cmp P1, P0
cmovle S2, P0
cmovle P0, P1
cmovge S2, P1
cmp S2, S0
cmovle S1, S2
cmovle S2, S0
cmovle S0, S1
cmp P3, P0
mov P1, P3
