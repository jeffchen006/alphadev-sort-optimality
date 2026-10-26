# n=5 model=out iset=I1 prefix14_class=13502
mov S2, P0
cmp P3, P1
cmovle S1, P3
cmovle P3, P1
cmovle P1, S1
cmp P2, P0
cmovl P0, P2
cmovg S2, P2
mov S0, P0
cmp P1, S0
cmovle P0, P1
cmovle P1, S0
cmp S2, P3
cmovl S1, P3
