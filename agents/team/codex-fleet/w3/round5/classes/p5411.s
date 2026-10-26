# n=5 model=out iset=I1 prefix14_class=5411
cmp P0, P2
cmovg S2, P2
mov S1, P1
cmovge P2, P0
cmovg P0, S2
cmp S1, P3
cmovle P1, P3
cmovle P3, S1
cmovge S1, P3
cmp S1, P0
cmovg P3, P0
cmovg P0, S1
cmp P2, P1
cmovle S1, P1
