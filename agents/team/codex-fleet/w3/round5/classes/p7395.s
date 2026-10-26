# n=5 model=out iset=I1 prefix14_class=7395
cmp P3, P2
cmovle S2, P3
cmovle P3, P2
cmovle P2, S2
cmp P0, P1
mov S1, P3
cmovge S2, P0
cmovge P0, P1
cmovg P1, S2
cmp P2, P0
mov S0, P0
cmovge P0, P2
cmovg P2, S0
cmp P1, P3
