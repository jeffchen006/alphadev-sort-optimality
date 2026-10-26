# n=5 model=out iset=I1 prefix14_class=447
cmp P1, P2
cmovle S2, P2
cmovge S2, P1
mov S1, P3
cmovle P2, P1
mov S0, P2
cmp S1, P0
cmovg P3, P0
cmovg P0, S1
cmp P3, S0
cmovle S0, P3
mov S0, S2
cmovle P3, P2
cmp S2, P0
