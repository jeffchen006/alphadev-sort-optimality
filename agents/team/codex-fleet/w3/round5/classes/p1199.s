# n=5 model=out iset=I1 prefix14_class=1199
cmp P3, P0
mov S0, P3
mov S2, P2
cmovle P3, P0
cmovle P0, S0
cmovle S0, P3
cmp P2, P1
cmovge P2, P1
cmovle S2, P1
cmp S0, S2
cmovge S0, S2
cmovge S2, P3
cmp P2, P0
cmovle P3, P2
