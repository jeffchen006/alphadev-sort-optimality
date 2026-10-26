# n=5 model=out iset=I1 prefix14_class=1316
cmp P3, P1
mov S2, P2
mov S1, P1
cmovle S1, P3
cmovle P3, P1
cmp S2, P0
cmovge S2, P0
cmovg P0, P2
cmp P3, P0
cmovg P1, P0
cmovg P0, P3
cmovle P1, P3
mov P3, S2
mov P0, P1
