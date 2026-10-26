# n=5 model=out iset=I1 prefix14_class=12261
mov S0, P1
cmp P0, P1
cmovge P1, P0
cmovle S0, P0
cmp P3, P2
cmovge S1, P2
cmovg P2, P3
cmovge P3, S1
mov S2, S0
cmp S0, P3
cmovle S0, P3
cmovg S2, P3
cmovge P3, S0
mov S2, P2
