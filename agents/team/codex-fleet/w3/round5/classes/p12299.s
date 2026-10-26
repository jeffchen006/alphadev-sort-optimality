# n=5 model=out iset=I1 prefix14_class=12299
cmp P1, P0
cmovle S2, P0
cmovge S2, P1
cmovge P1, P0
cmovle P0, P1
cmp P3, P2
cmovge S1, P2
cmovge P2, P3
cmovg P3, S1
cmp P1, P3
cmovge P0, P3
cmovle P1, P3
cmp S2, P2
cmovle S0, P2
