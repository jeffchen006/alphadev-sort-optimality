# n=5 model=out iset=I1 prefix14_class=3712
cmp P0, P3
cmovle S1, P0
cmovle P0, P3
cmovg S1, P3
cmp P1, P2
cmovle S2, P1
cmovle P1, P2
cmovle P2, S2
mov S0, P0
cmp S1, P2
cmovle P3, P2
cmovle P2, S1
cmovl S1, P3
cmp P1, P0
