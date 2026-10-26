# n=5 model=out iset=I1 prefix14_class=9438
cmp P1, P0
cmovle S2, P0
cmovle P0, P1
cmovl P1, S2
mov S1, P2
cmp P2, P3
cmovle P2, P3
cmovl P3, S1
cmp P3, P0
mov S1, P0
cmovle P0, P3
cmovg S1, P3
cmp P2, P1
mov S0, S1
