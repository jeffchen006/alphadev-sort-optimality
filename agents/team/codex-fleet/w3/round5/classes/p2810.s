# n=5 model=out iset=I1 prefix14_class=2810
mov S1, P1
mov S2, P2
cmp S1, P0
cmovg S1, P0
cmovg P0, P1
cmp P3, S2
cmovle P2, P3
cmovle P3, S2
cmp P3, P0
cmovg S2, P0
cmovg P0, P3
cmovg P3, S2
cmp P2, S1
cmovle P0, P2
