# n=5 model=out iset=I1 prefix14_class=10273
cmp P1, P2
mov S2, P3
cmovge S1, P1
cmovle S1, P2
cmovge P1, P2
cmp P3, P0
cmovle S2, P0
cmovge P3, P0
cmp S2, S1
mov S0, P3
cmovge P0, S1
cmovg S1, S2
cmovg S2, P0
mov P2, S2
