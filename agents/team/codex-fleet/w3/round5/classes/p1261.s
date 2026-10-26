# n=5 model=out iset=I1 prefix14_class=1261
mov S2, P3
cmp P1, P3
cmovg S2, P1
cmovge P1, P3
cmp P2, P0
mov S0, S2
cmovle S1, P0
cmovg S1, P2
cmovle P0, P2
cmp S0, S1
cmovle S0, S1
mov S0, P1
cmovg S2, S1
mov P2, S2
