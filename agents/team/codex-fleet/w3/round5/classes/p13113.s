# n=5 model=out iset=I1 prefix14_class=13113
mov S0, P3
cmp P0, S0
cmovl P3, P0
mov S2, P3
cmovle P0, S0
cmp P2, P1
cmovl S0, P2
cmovle P2, P1
cmovl P1, S0
cmp S2, P1
mov S1, P2
cmovle S2, P1
cmovle P1, P3
cmovl P3, S2
