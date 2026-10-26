# n=5 model=out iset=I1 prefix14_class=1737
mov S0, P1
cmp S0, P0
cmovle S0, P0
mov S1, S0
cmovle P0, P1
cmp P3, P2
cmovle P1, P2
cmovle P2, P3
cmovle P3, P1
cmp P0, P2
cmovg S2, P0
cmovle S2, P2
cmovg P0, P2
cmp P3, S0
