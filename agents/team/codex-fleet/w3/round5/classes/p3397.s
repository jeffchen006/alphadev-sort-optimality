# n=5 model=out iset=I1 prefix14_class=3397
mov S1, P1
cmp P2, P3
mov S0, P3
cmovle S0, P2
cmovge P3, P2
cmp P0, S1
cmovle P1, P0
cmovge S1, P0
cmp S0, P1
mov S2, P1
cmovge S2, S0
cmovge S0, P1
cmp S1, P3
mov S0, S2
