# n=5 model=out iset=I1 prefix14_class=4330
cmp P2, P3
cmovle S2, P2
cmovg S2, P3
cmovle P2, P3
cmp P1, P0
cmovl P3, P0
cmovle P0, P1
cmovl P1, P3
cmp P0, S2
mov S0, P0
cmovle P0, S2
cmovl S2, S0
cmp P2, P1
cmovl S1, P1
