# n=5 model=out iset=I1 prefix14_class=6209
cmp P0, P3
cmovg S2, P3
cmovle S2, P0
mov S1, P1
cmovle P0, P3
cmp P2, S1
cmovg P1, P2
cmovle S1, P2
cmp P1, P0
cmovle S0, P1
cmovl P1, P0
cmovle P0, S0
cmp S1, S2
cmovg P1, S1
