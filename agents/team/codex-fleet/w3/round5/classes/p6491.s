# n=5 model=out iset=I1 prefix14_class=6491
mov S1, P0
cmp P1, S1
cmovg P0, P1
cmovle S1, P1
mov S2, P3
cmp P2, P3
cmovge S2, P2
cmovle P3, P2
cmp S2, P0
mov P1, P0
cmovle P1, S2
cmovle S2, P0
cmp S1, P3
cmovle S2, P3
