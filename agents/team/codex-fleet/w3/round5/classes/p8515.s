# n=5 model=out iset=I1 prefix14_class=8515
cmp P0, P3
cmovl S0, P3
mov S1, P2
cmovl P3, P0
cmovl P0, S0
cmp S1, P1
cmovle P2, P1
cmovle P1, S1
cmovl S1, P2
cmp P0, P2
cmovg S1, P0
cmovle P2, P0
cmp P3, P1
cmovl P0, P3
