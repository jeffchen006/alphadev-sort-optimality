# n=5 model=out iset=I1 prefix14_class=5441
cmp P2, P1
cmovle S2, P2
cmovle P2, P1
cmovge S2, P1
mov S1, P3
cmp P0, S1
cmovge S1, P0
cmovg P0, P3
cmp P0, S2
mov P1, S2
cmovg P1, P0
cmovle S2, P0
cmp P2, S1
cmovle P0, P2
