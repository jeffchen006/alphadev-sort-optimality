# n=5 model=out iset=I1 prefix14_class=3308
mov S1, P3
mov S2, P1
cmp P2, P3
cmovle P3, P2
cmovg S1, P2
cmp P0, P1
cmovg S2, P0
cmovg P0, P1
cmovle P1, P0
cmp P0, P3
cmovle P0, P3
cmovg P1, P3
cmp S2, S1
cmovg P3, P0
