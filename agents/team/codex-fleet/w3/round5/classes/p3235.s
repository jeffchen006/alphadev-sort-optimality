# n=5 model=out iset=I1 prefix14_class=3235
mov S1, P3
mov S2, P1
cmp P2, P1
cmovge P1, P2
cmovle S2, P2
cmp P0, S1
cmovle S1, P0
cmovge P3, P0
cmp S2, S1
cmovge S0, S1
cmovge S1, S2
mov P2, P3
cmovg S2, S0
cmp P1, P3
