# n=5 model=out iset=I1 prefix14_class=9220
cmp P3, P2
cmovge S0, P2
cmovg P2, P3
cmovge P3, S0
cmp P0, P1
mov S2, P3
cmovge S1, P0
cmovle S1, P1
cmovle P1, P0
cmp P3, P1
cmovge S2, P1
cmovg P1, P3
cmp S1, P2
cmovle S0, S1
