# n=5 model=out iset=I1 prefix14_class=5977
cmp P0, P3
cmovge S1, P3
mov S0, P1
cmovge P3, P0
cmovle S1, P0
cmp P1, P2
mov S2, S1
cmovg S0, P2
cmovge P2, P1
cmp P3, P2
cmovle P1, P2
cmovle P2, P3
cmovle P3, P1
cmp S0, S2
