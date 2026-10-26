# n=5 model=out iset=I1 prefix14_class=4803
mov S2, P2
cmp P1, S2
cmovg P2, P1
cmovle S2, P1
cmp P0, P3
cmovg S1, P0
cmovge P0, P3
cmovg P3, S1
cmp S2, P0
cmovle P1, P0
cmovge P1, S2
cmovle P0, S2
cmp P2, P3
mov P0, P3
