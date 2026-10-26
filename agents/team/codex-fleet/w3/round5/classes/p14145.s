# n=5 model=out iset=I1 prefix14_class=14145
mov S2, P3
cmp P0, P1
cmovle S1, P1
cmovle P1, P0
cmovle P0, S1
cmp P2, S2
cmovg S2, P2
cmovg P2, P3
mov P3, S2
cmp S2, P0
cmovg P3, P0
cmovg P0, S2
cmp P2, P1
cmovle P0, P2
