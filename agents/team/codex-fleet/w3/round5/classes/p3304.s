# n=5 model=out iset=I1 prefix14_class=3304
mov S2, P3
cmp P1, S2
mov S0, P0
cmovg S2, P1
cmovle P3, P1
cmp P0, P2
cmovg P0, P2
cmovle S0, P2
cmp P3, P0
cmovle S1, P3
cmovg S1, P0
cmovle P3, P0
cmp S2, S0
cmovl P1, S2
