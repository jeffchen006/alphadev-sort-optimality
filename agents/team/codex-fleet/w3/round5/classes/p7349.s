# n=5 model=out iset=I1 prefix14_class=7349
cmp P3, P2
cmovg S1, P2
cmovg P2, P3
cmovle S1, P3
cmp P0, P1
cmovle S0, P1
cmovle P1, P0
mov P3, P1
cmovl P0, S0
cmp P1, S1
cmovl P3, S1
cmovle S1, P1
mov S2, P0
cmp P0, P2
