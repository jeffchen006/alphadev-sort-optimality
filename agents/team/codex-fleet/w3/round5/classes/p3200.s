# n=5 model=out iset=I1 prefix14_class=3200
cmp P0, P3
mov S2, P3
cmovle S2, P0
cmovg P3, P0
cmp P1, P2
cmovge S1, P2
cmovg P2, P1
cmovle S1, P1
cmp S1, S2
cmovle P1, S2
cmovg P1, S1
cmovge S1, S2
cmp P2, P3
cmovle P0, P3
