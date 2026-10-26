# n=5 model=out iset=I1 prefix14_class=9981
cmp P1, P0
mov S0, P1
mov S2, P2
cmovle S0, P0
cmovle P0, P1
cmp P3, S2
cmovg S2, P3
cmovle P2, P3
cmp S2, S0
mov S1, S0
cmovle S0, S2
cmovle S2, S1
cmp P2, P0
cmovle P1, P2
