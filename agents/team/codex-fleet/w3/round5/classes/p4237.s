# n=5 model=out iset=I1 prefix14_class=4237
cmp P3, P0
cmovge S1, P0
cmovge P0, P3
cmovge P3, S1
mov S0, P2
cmp P1, P2
cmovg P2, P1
cmovg P1, S0
cmp P3, P1
cmovge S2, P3
cmovle S2, P1
cmovle P1, P3
cmp P2, P0
cmovle P3, P2
