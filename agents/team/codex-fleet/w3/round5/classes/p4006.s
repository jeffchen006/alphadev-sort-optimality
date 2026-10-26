# n=5 model=out iset=I1 prefix14_class=4006
cmp P1, P3
cmovle S0, P1
mov S2, P0
cmovge S0, P3
cmovle P1, P3
cmp S2, P2
cmovge S2, P2
cmovge P2, P0
cmp S0, S2
mov S1, S0
cmovge S1, S2
cmovge S2, S0
cmp P2, P1
cmovle S1, P2
