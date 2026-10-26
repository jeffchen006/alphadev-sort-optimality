# n=5 model=out iset=I1 prefix14_class=6587
cmp P2, P0
cmovle S1, P0
cmovg S1, P2
cmovle P0, P2
cmp P3, P1
cmovle S2, P3
cmovle P3, P1
cmovl P1, S2
mov S0, P3
cmp P3, S1
cmovg S0, S1
cmovg S1, P3
mov P3, P1
cmp P0, P3
