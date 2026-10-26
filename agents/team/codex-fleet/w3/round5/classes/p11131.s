# n=5 model=out iset=I1 prefix14_class=11131
cmp P1, P0
cmovl S2, P1
mov S1, P2
cmovl P1, P0
cmovl P0, S2
cmp P3, P2
cmovl S1, P3
cmovle P3, P2
cmp P1, P3
mov S0, P1
cmovl P1, P3
cmovl P3, S0
cmp P0, S1
cmovge S0, S1
