# n=5 model=out iset=I1 prefix14_class=1016
mov S1, P1
cmp S1, P0
cmovle S1, P0
cmovle P0, P1
mov S2, P2
cmp P2, P3
mov P1, S1
cmovg S2, P3
cmovg P3, P2
cmp P3, P1
cmovge S1, P3
cmovge P3, P1
cmp P0, S2
cmovge S1, P0
