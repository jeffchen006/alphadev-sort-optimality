# n=5 model=out iset=I1 prefix14_class=4319
cmp P2, P3
cmovge S0, P3
cmovl S0, P2
cmovle P2, P3
mov S2, P0
cmp P1, P0
cmovle P0, P1
cmovl P1, S2
mov S1, P0
cmp P0, S0
cmovle P0, S0
cmovl S0, S1
cmp P1, P2
cmovl S0, P2
