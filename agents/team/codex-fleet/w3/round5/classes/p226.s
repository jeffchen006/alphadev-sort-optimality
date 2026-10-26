# n=5 model=out iset=I1 prefix14_class=226
cmp P0, P2
cmovge S2, P0
cmovle S2, P2
cmovle P2, P0
mov S0, P3
cmp P3, P1
cmovg P3, P1
cmovge P1, S0
cmp P3, P2
cmovge P0, P3
cmovle P0, P2
cmovle P2, P3
cmp P1, S2
cmovle S0, S2
