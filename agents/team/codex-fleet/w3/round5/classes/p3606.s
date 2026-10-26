# n=5 model=out iset=I1 prefix14_class=3606
mov S0, P1
cmp S0, P0
cmovl S0, P0
cmovle P0, P1
mov S1, P3
cmp P2, P3
cmovl P3, P2
cmovl P2, S1
cmovl S1, P3
cmp P0, P3
cmovl P3, P0
cmovl P0, S1
cmp P2, S0
cmovle P1, P2
