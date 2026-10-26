# n=5 model=out iset=I1 prefix14_class=10228
cmp P2, P0
cmovle S1, P2
cmovle P2, P0
mov S0, P3
cmovle P0, S1
cmp P1, S0
cmovge P3, P1
cmovge P1, S0
mov S2, P2
cmp P3, S2
cmovg S2, P3
cmovle P2, P3
cmp P0, P1
cmovle S1, P0
