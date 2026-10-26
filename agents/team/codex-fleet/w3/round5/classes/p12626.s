# n=5 model=out iset=I1 prefix14_class=12626
mov S2, P3
cmp P0, S2
cmovle P3, P0
cmovle P0, S2
cmp P2, P1
cmovle S1, P1
cmovle P1, P2
mov S0, P0
cmovl P2, S1
cmp P1, P3
cmovle S2, P3
cmovle P3, P1
cmovl P1, S2
cmp P2, P0
