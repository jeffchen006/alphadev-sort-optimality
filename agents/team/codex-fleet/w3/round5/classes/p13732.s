# n=5 model=out iset=I1 prefix14_class=13732
mov S2, P0
cmp P1, P3
cmovle S1, P3
cmovle P3, P1
cmovle P1, S1
cmp P0, P2
cmovg P0, P2
cmovle S2, P2
cmp S2, P1
mov S0, P3
cmovg P2, P1
cmovg P1, S2
cmovg S2, P2
cmp P3, P0
