# n=5 model=out iset=I1 prefix14_class=4921
mov S1, P2
cmp P0, S1
cmovl S1, P0
cmovl P0, P2
cmp P1, P3
cmovl S2, P1
mov P2, S1
cmovl P1, P3
cmovl P3, S2
cmp P3, S1
cmovle P2, P3
mov S0, P1
cmovl P3, S1
cmp S0, P0
