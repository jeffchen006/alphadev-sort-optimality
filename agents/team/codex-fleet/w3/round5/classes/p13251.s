# n=5 model=out iset=I1 prefix14_class=13251
mov S1, P1
cmp P3, S1
cmovl S1, P3
mov S0, P0
cmovl P3, P1
cmp S0, P2
cmovl P0, P2
cmovle P2, S0
cmp S1, P2
cmovl S0, P2
cmovle P2, S1
cmovl S1, S0
mov P2, P0
cmp P0, P3
