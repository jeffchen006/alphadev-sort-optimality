# n=5 model=out iset=I1 prefix14_class=9592
cmp P2, P3
mov S2, P2
cmovle S2, P3
cmovle P3, P2
cmp P0, P1
cmovge S1, P1
mov S0, S2
cmovge P1, P0
cmovge P0, S1
cmp S0, P1
cmovge S0, P1
cmovg P1, S2
cmp P3, P0
cmovle S2, P0
