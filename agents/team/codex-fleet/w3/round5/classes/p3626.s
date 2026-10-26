# n=5 model=out iset=I1 prefix14_class=3626
cmp P1, P2
cmovle S1, P1
cmovle P1, P2
cmovle P2, S1
cmp P0, P3
cmovle S0, P3
cmovl P3, P0
cmovle P0, S0
mov S0, P2
cmp P3, P2
cmovle S0, P3
cmovg P2, P3
cmp P0, P1
cmovg S2, P1
