# n=5 model=out iset=I1 prefix14_class=8247
cmp P1, P2
cmovle S0, P2
cmovle P2, P1
cmovle P1, S0
mov S1, P2
mov S2, P3
cmp P0, P3
cmovge P3, P0
cmovg P0, S2
cmp P2, P0
cmovge S1, P0
cmovle P2, P0
cmp P1, P3
mov S1, P1
