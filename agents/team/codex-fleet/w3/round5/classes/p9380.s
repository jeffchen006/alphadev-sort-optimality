# n=5 model=out iset=I1 prefix14_class=9380
mov S2, P3
cmp P1, P3
cmovg P3, P1
cmovg P1, S2
mov S1, P0
cmp S1, P2
cmovle P0, P2
cmovle P2, S1
mov S2, P1
cmp P2, P1
cmovg S2, P2
cmovle P1, P2
cmp P0, P3
cmovle S1, P0
