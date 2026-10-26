# n=5 model=out iset=I1 prefix14_class=1432
cmp P1, P2
mov S1, P3
cmovge S0, P1
cmovge P1, P2
cmovge P2, S0
cmp P0, S1
cmovge P3, P0
cmovge P0, S1
mov S1, P3
cmp P3, P2
cmovge P3, P2
mov S2, P0
cmovle S1, P2
cmovle P2, P3
