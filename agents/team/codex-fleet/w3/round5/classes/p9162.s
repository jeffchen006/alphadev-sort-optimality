# n=5 model=out iset=I1 prefix14_class=9162
mov S2, P3
cmp P1, P3
cmovle S2, P1
cmovge P3, P1
cmp P2, P0
cmovle P1, P0
cmovle P0, P2
cmovle P2, P1
mov S0, P3
cmp S2, P0
cmovge P1, S2
cmovge S2, P0
cmovge P0, P1
cmp P2, S0
