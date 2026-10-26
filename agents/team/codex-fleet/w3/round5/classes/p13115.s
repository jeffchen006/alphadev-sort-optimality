# n=5 model=out iset=I1 prefix14_class=13115
cmp P0, P3
cmovl S0, P3
cmovle P3, P0
cmovl P0, S0
cmp P2, P1
cmovle S0, P2
cmovle P2, P1
cmovle P1, S0
mov S1, P1
cmp S1, P3
mov S2, P2
cmovle S1, P3
cmovle P3, P1
cmovl P1, S1
