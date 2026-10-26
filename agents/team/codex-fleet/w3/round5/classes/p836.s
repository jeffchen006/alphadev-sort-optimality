# n=5 model=out iset=I1 prefix14_class=836
cmp P2, P1
mov S2, P3
cmovle S0, P1
cmovg S0, P2
cmovge P2, P1
cmp P3, P0
cmovg S2, P0
cmovge P0, P3
cmp P0, S0
mov P3, S2
cmovge S1, S0
cmovge S0, P0
cmovle S1, P0
cmp P3, P2
