# n=5 model=out iset=I1 prefix14_class=13249
mov S1, P3
cmp P0, S1
cmovl S1, P0
mov S0, P1
cmovl P0, P3
cmp S0, P2
cmovl P1, P2
cmovle P2, S0
cmp S1, P2
cmovl S0, P2
cmovle P2, S1
mov P2, P1
cmovl S1, S0
cmp P1, P0
