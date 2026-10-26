# n=5 model=out iset=I1 prefix14_class=4527
mov S2, P2
cmp P2, P1
mov S1, P3
cmovle P2, P1
cmovge S2, P1
cmp P3, P0
cmovg S1, P0
cmovle P3, P0
mov S0, P3
cmp P3, P2
cmovge P3, P2
cmovg P2, S0
cmp S2, S1
cmovle S0, P3
