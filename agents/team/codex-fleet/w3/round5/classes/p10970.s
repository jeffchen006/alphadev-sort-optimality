# n=5 model=out iset=I1 prefix14_class=10970
cmp P3, P1
cmovle S1, P3
cmovle P3, P1
cmovle P1, S1
cmp P2, P0
cmovg S2, P2
cmovge P2, P0
cmovg P0, S2
cmp P0, P3
mov S0, P3
cmovle P3, P0
cmovge S0, P0
cmp P1, P2
cmovle P0, P2
