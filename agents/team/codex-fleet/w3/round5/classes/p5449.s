# n=5 model=out iset=I1 prefix14_class=5449
cmp P3, P2
cmovg S2, P2
cmovle S2, P3
cmovle P3, P2
cmp P1, P0
mov P2, S2
cmovge S1, P0
cmovge P0, P1
mov S0, P0
cmovge P1, S1
cmp P1, P2
cmovle P2, P1
cmovle P1, S2
mov S2, P1
