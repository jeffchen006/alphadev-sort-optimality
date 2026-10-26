# n=5 model=out iset=I1 prefix14_class=8249
cmp P1, P2
mov S0, P2
cmovle P2, P1
mov S2, P3
mov S1, P2
cmovle P1, S0
cmp P0, P3
cmovg P3, P0
cmovg P0, S2
cmp S1, P0
cmovg P2, P0
cmovle S1, P0
cmp P1, P3
cmovle S2, P3
