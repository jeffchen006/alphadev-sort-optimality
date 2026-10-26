# n=5 model=out iset=I1 prefix14_class=8288
mov S1, P0
cmp S1, P2
cmovg S1, P2
cmovge P2, P0
cmp P1, P3
cmovle S2, P3
mov P0, S1
cmovle P3, P1
cmovle P1, S2
cmp S1, P3
cmovg S1, P3
cmovle P0, P3
cmp P2, P1
cmovge S1, P1
