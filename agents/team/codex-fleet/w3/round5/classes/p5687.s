# n=5 model=out iset=I1 prefix14_class=5687
cmp P1, P2
cmovge S1, P2
cmovle S1, P1
mov S0, P3
cmovge P2, P1
cmp P3, P0
mov S2, S1
cmovg S0, P0
cmovge P0, P3
cmp S0, S2
cmovle S1, S0
cmovle S0, S2
cmp P2, P0
cmovg S2, P2
