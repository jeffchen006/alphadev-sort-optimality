# n=5 model=out iset=I1 prefix14_class=14433
cmp P2, P0
mov S1, P3
mov S2, P2
cmovge S2, P0
cmovle P2, P0
cmp P1, S1
cmovle P3, P1
cmovg S1, P1
cmp S2, P3
cmovge P1, S2
cmovge S2, P3
cmovg P3, P1
cmp P2, S1
cmovle S2, P2
