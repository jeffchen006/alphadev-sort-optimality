# n=5 model=out iset=I1 prefix14_class=14081
cmp P0, P1
cmovle S0, P0
cmovle P0, P1
cmovge S0, P1
mov S2, P0
cmp P3, P2
cmovge P1, P3
cmovg P3, P2
cmovge P2, P1
cmp S2, P2
mov S1, P3
cmovle S2, P2
cmovle P2, P0
cmp P3, S0
