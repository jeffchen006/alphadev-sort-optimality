# n=5 model=out iset=I1 prefix14_class=7559
mov S2, P0
mov S1, P2
cmp P0, P3
cmovg S2, P3
cmovle P0, P3
cmp P1, P2
cmovge S1, P1
cmovge P1, P2
cmp S2, P1
cmovg S0, S2
cmovle S0, P1
cmovle P1, S2
cmp S1, P0
cmovle P2, P0
