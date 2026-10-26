# n=5 model=out iset=I1 prefix14_class=6983
cmp P3, P0
mov S0, P0
cmovg S0, P3
cmovge P3, P0
cmp P1, P2
cmovle S1, P2
cmovg S1, P1
cmovle P2, P1
mov S2, S0
cmp S2, S1
cmovle S0, S1
cmovge S2, S1
cmp P2, P3
cmovle S1, P3
