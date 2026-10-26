# n=5 model=out iset=I1 prefix14_class=6058
cmp P1, P0
mov S2, P1
cmovle P1, P0
cmovle P0, S2
cmp P3, P2
cmovle S1, P2
cmovl P2, P3
mov S2, P1
cmovl P3, S1
mov S0, P0
cmp P1, P3
cmovl P1, P3
cmovle P3, S2
cmp P0, P2
