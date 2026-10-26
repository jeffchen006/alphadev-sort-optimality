# n=5 model=out iset=I1 prefix14_class=13611
cmp P2, P1
cmovle S1, P1
mov S0, P3
cmovle P1, P2
cmovl P2, S1
cmp P0, P3
cmovl S0, P0
mov S2, S0
cmovle P0, P3
cmp P1, S0
cmovl S2, P1
cmovl P1, S0
mov S2, P2
cmp S2, P0
