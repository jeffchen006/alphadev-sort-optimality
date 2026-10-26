# n=5 model=out iset=I1 prefix14_class=13112
cmp P0, P3
cmovl S1, P3
cmovle P3, P0
cmovl P0, S1
cmp P1, P2
cmovle S1, P1
cmovle P1, P2
cmovle P2, S1
mov S2, P3
cmp S2, P2
cmovl S2, P2
cmovl P2, P3
cmovl P3, S2
mov S0, P1
