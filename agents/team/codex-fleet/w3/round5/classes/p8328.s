# n=5 model=out iset=I1 prefix14_class=8328
cmp P2, P1
cmovle S2, P2
cmovg S2, P1
cmovle P2, P1
cmp P3, P0
cmovge P1, P0
cmovge P0, P3
mov S0, P0
cmovge P3, P1
cmp S2, P3
cmovg S1, P3
cmovle S1, S2
cmovle S2, P3
cmp S0, P2
