# n=5 model=out iset=I1 prefix14_class=1299
mov S2, P3
cmp P3, P0
cmovle S2, P0
cmovg P3, P0
mov P0, P2
cmp P0, P1
cmovle P2, P1
cmovle P1, P0
mov S0, P2
cmp S0, S2
cmovle P2, S2
cmovle S2, S0
cmp P1, P3
cmovg P0, P1
