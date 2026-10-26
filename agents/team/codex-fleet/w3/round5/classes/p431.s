# n=5 model=out iset=I1 prefix14_class=431
mov S2, P3
cmp P2, P0
cmovg S1, P2
cmovle S1, P0
cmovle P0, P2
cmp P3, P1
cmovg S2, P1
cmovg P1, P3
cmp P0, S2
cmovle P2, P0
cmovg P2, S2
cmovle P0, S2
cmp P1, S1
cmovle P3, P1
