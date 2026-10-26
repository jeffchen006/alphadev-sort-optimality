# n=5 model=out iset=I1 prefix14_class=10118
mov S1, P3
cmp P0, P2
cmovg S2, P0
cmovle S2, P2
cmovge P0, P2
cmp P3, P1
cmovge S1, P1
cmovle P3, P1
mov S0, S2
cmp P3, S2
cmovle S0, P3
cmovle P3, S2
cmp P0, S1
cmovle P2, S1
