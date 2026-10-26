# n=5 model=out iset=I1 prefix14_class=7387
cmp P3, P2
cmovle S1, P3
cmovle P3, P2
cmovle P2, S1
mov S0, P1
mov S2, P3
cmp P1, P0
cmovge P1, P0
cmovg P0, S0
cmp P2, P1
cmovge S1, P1
cmovge P1, P2
cmovg P2, S1
mov P2, P1
