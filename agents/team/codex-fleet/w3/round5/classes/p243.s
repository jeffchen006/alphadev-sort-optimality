# n=5 model=out iset=I1 prefix14_class=243
cmp P0, P2
mov S1, P1
mov S2, P2
cmovle P2, P0
cmovg S2, P0
mov P0, S2
cmp S1, P3
cmovge S1, P3
cmovg P3, P1
cmp S1, P2
cmovle P1, P2
cmovle P2, S1
cmovle S1, P1
cmp P0, P3
