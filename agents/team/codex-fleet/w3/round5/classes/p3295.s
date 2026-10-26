# n=5 model=out iset=I1 prefix14_class=3295
mov S0, P0
cmp P3, S0
mov S2, P1
cmovge P0, P3
cmovle S0, P3
cmovle P3, P0
cmp P2, P1
mov S1, S0
cmovg S2, P2
cmovge P2, P1
cmp S0, P2
cmovge S0, P2
cmovle S1, P2
mov S0, S1
