# n=5 model=out iset=I1 prefix14_class=12831
cmp P3, P0
cmovle S2, P3
cmovle P3, P0
mov S1, P1
cmovle P0, S2
cmp S1, P2
cmovg P1, P2
mov S0, P1
cmovg P2, S1
cmp P0, P1
cmovle P1, P0
cmovg S0, P0
cmp P3, P2
cmovle P1, P3
