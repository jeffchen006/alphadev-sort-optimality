# n=5 model=out iset=I1 prefix14_class=6766
cmp P3, P1
mov S2, P2
cmovle S1, P3
cmovle P3, P1
cmovge S1, P1
cmp P0, S2
cmovg S2, P0
cmovg P0, P2
cmp S2, P3
cmovge S0, S2
cmovge S2, P3
cmovge P3, S0
cmp S1, P0
cmovge P2, S1
