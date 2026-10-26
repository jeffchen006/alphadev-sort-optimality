# n=5 model=out iset=I1 prefix14_class=4466
cmp P3, P2
cmovge S2, P2
cmovge P2, P3
cmovge P3, S2
mov S0, P0
mov S1, P3
cmp P1, P0
cmovle P0, P1
cmovle P1, S0
cmovge S0, P1
cmp S0, P2
cmovle S0, P2
cmovle P2, P1
cmp P3, P0
