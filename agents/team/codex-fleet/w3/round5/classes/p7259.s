# n=5 model=out iset=I1 prefix14_class=7259
cmp P0, P2
cmovle S2, P0
mov S1, P1
cmovl P0, P2
cmovl P2, S2
mov S0, P2
cmp P3, S1
cmovle S1, P3
cmovle P3, P1
cmp P2, S1
cmovle P2, S1
cmovg S0, S1
cmp P3, P0
mov S1, P0
