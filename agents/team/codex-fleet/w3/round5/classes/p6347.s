# n=5 model=out iset=I1 prefix14_class=6347
cmp P3, P2
cmovg S0, P3
cmovg P3, P2
cmovg P2, S0
mov S2, P2
cmp P1, P0
mov S1, P0
cmovle P0, P1
cmovg S1, P1
cmp S1, S2
cmovg P2, S1
cmovle S2, S1
cmp P0, P3
cmovle P1, P0
