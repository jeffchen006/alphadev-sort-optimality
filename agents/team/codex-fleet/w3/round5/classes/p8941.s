# n=5 model=out iset=I1 prefix14_class=8941
cmp P3, P2
cmovge S2, P3
cmovle S2, P2
cmovge P3, P2
cmp P0, P1
mov S0, P0
cmovle P0, P1
cmovle P1, S0
cmp P0, S2
mov S1, P0
cmovge P0, S2
cmovle S1, S2
cmp P1, P3
cmovle S0, P3
