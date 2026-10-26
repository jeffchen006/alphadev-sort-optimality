# n=5 model=out iset=I1 prefix14_class=10231
cmp P2, P0
cmovle S1, P2
mov S0, P1
cmovle P2, P0
cmovle P0, S1
cmp P3, P1
mov S2, P2
cmovg S0, P3
cmovg P3, P1
cmp S0, S2
cmovle P2, S0
cmovg S2, S0
cmp P0, P3
cmovle S0, P0
