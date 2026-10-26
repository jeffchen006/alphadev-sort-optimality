# n=5 model=out iset=I1 prefix14_class=1408
cmp P2, P0
mov S1, P1
mov S2, P0
cmovle P0, P2
cmovle P2, S2
cmp P3, S1
cmovle S1, P3
cmovge P1, P3
cmp P2, P1
cmovge P3, P1
mov S0, S1
cmovle P3, P2
cmovle P2, P1
cmovle P1, P3
