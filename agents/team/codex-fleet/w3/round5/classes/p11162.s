# n=5 model=out iset=I1 prefix14_class=11162
cmp P1, P3
cmovle S1, P1
mov S2, P0
cmovle P1, P3
cmovle P3, S1
cmp P0, P2
cmovle S2, P2
cmovge P0, P2
cmp S2, P1
mov S0, S2
cmovg S2, P1
cmovle S0, P1
cmp P3, P0
mov S0, P3
