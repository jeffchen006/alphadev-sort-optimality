# n=5 model=out iset=I1 prefix14_class=9693
cmp P2, P1
cmovg S2, P2
mov S1, P0
cmovge P2, P1
cmovg P1, S2
cmp P3, S1
cmovle P0, P3
cmovge S1, P3
mov P3, S1
cmp S1, P1
cmovle S1, P1
cmovg P3, P1
cmp P2, P0
mov S1, P3
