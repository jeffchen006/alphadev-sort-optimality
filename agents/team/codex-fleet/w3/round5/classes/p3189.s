# n=5 model=out iset=I1 prefix14_class=3189
mov S2, P0
cmp P2, P0
cmovg P0, P2
cmovle S2, P2
cmp P3, P1
cmovge S1, P3
cmovg P3, P1
cmovg P1, S1
cmp S2, P3
cmovge P2, P3
cmovle P2, S2
cmovle S2, P3
mov S0, P0
cmp P1, P0
