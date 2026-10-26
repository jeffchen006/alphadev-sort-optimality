# n=5 model=out iset=I1 prefix14_class=12369
cmp P2, P0
mov S2, P3
cmovle S1, P0
cmovle P0, P2
cmovle P2, S1
cmp P1, P3
cmovle P3, P1
cmovle P1, S2
cmp P0, P3
mov S2, P1
cmovle S1, P3
cmovl P3, P0
cmovle P0, S1
cmp P2, S2
