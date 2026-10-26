# n=5 model=out iset=I1 prefix14_class=11805
cmp P1, P2
cmovle S2, P2
cmovle P2, P1
cmovle P1, S2
cmp P3, P0
cmovle S0, P3
cmovle P3, P0
cmovl P0, S0
mov S1, P1
cmp P3, S1
cmovle S1, P3
cmovg P1, P3
cmp P0, P2
cmovle P1, P0
