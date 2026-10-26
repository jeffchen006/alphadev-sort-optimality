# n=5 model=out iset=I1 prefix14_class=13157
cmp P2, P0
cmovle S1, P0
cmovle P0, P2
cmovle P2, S1
cmp P1, P3
cmovge S2, P1
cmovge P1, P3
cmovle S2, P3
mov S0, P2
cmp P0, P1
cmovge P3, P0
cmovge P0, P1
cmovge P1, P3
cmp P2, S2
