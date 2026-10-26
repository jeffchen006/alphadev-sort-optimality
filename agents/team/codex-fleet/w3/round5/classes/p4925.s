# n=5 model=out iset=I1 prefix14_class=4925
mov S2, P3
cmp P0, P3
cmovl S2, P0
cmovle P0, P3
cmp P2, P1
cmovl P3, P2
cmovle P2, P1
mov S0, S2
cmovl P1, P3
cmp P1, S2
mov S1, P0
cmovle S0, P1
cmovle P1, S2
cmp S1, P2
