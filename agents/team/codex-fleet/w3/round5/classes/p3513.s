# n=5 model=out iset=I1 prefix14_class=3513
mov S1, P1
cmp P3, S1
mov S2, P2
cmovle S1, P3
cmovge P1, P3
cmp P0, P2
cmovle S2, P0
cmovge P2, P0
cmp S2, S1
cmovge S0, S1
cmovge S1, S2
mov P0, P2
cmovge S2, S0
cmp P1, P2
