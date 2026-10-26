# n=5 model=out iset=I1 prefix14_class=238
cmp P2, P0
cmovge S2, P2
cmovle S2, P0
mov S1, P1
cmovle P0, P2
cmp P1, P3
mov P2, P0
cmovg S1, P3
cmovg P3, P1
cmp S1, P0
cmovg P0, S1
cmovle P2, S1
cmovle S1, P0
mov P2, S2
