# n=5 model=out iset=I1 prefix14_class=2424
cmp P2, P0
cmovge S0, P2
mov S2, P3
cmovle S0, P0
cmovle P0, P2
cmp S2, P1
cmovle P3, P1
cmovle P1, S2
cmp S0, P3
cmovg S1, P3
cmovge P3, S0
mov S2, P1
cmovg S0, S1
cmp P0, P1
