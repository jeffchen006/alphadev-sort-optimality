# n=5 model=out iset=I1 prefix14_class=3103
mov S2, P3
cmp P3, P0
cmovle P3, P0
cmovl P0, S2
mov S1, P2
mov S2, P0
cmp P1, S1
cmovle S1, P1
cmovl P1, P2
cmp P0, S1
cmovg S2, S1
cmovle P0, S1
cmp P1, P3
cmovle S1, P3
