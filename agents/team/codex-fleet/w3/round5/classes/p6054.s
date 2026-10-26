# n=5 model=out iset=I1 prefix14_class=6054
cmp P3, P1
mov S0, P2
cmovle S2, P3
cmovl P3, P1
cmovle P1, S2
cmp P0, S0
cmovle P2, P0
cmovle P0, S0
cmp P3, P0
cmovle S1, P0
cmovle P0, P3
cmovg S1, P3
mov S0, P1
cmp P1, P2
