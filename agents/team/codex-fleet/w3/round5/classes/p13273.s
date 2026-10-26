# n=5 model=out iset=I1 prefix14_class=13273
cmp P3, P2
mov S1, P1
cmovl S2, P2
cmovl P2, P3
cmovl P3, S2
cmp P1, P0
cmovl S1, P0
cmovl P0, P1
mov S0, P0
cmp P2, P0
cmovle P0, P2
cmovl P2, S0
mov P1, P2
cmp S1, P3
