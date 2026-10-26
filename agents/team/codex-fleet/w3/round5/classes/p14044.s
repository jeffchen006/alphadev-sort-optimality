# n=5 model=out iset=I1 prefix14_class=14044
mov S2, P3
cmp P3, P0
cmovge P3, P0
cmovge P0, S2
cmp P2, P1
mov S1, P0
cmovge S0, P2
cmovg P2, P1
cmovge P1, S0
cmp P1, S1
cmovle P0, P1
cmovle P1, S1
cmovle S1, P0
cmp P3, P2
