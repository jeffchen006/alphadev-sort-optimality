# n=5 model=out iset=I1 prefix14_class=10268
mov S2, P1
mov S0, P3
cmp P2, S2
cmovge P1, P2
cmovle S2, P2
cmp P3, P0
cmovge P3, P0
cmovle S0, P0
cmp S0, P1
cmovge P0, P1
cmovge P1, S0
cmovge S0, P0
cmp S2, P3
mov S1, S0
