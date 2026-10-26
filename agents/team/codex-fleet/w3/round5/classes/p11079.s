# n=5 model=out iset=I1 prefix14_class=11079
mov S2, P1
mov S1, P3
cmp S1, P0
cmovle P3, P0
cmovl P0, S1
cmp P1, P2
cmovl S2, P2
cmovle P2, P1
cmp P3, S2
cmovl P1, S2
cmovl S2, P3
cmovl P3, P1
cmp P0, P2
cmovg S0, P0
