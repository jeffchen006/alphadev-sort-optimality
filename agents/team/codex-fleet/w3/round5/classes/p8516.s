# n=5 model=out iset=I1 prefix14_class=8516
cmp P2, P3
cmovl S0, P3
mov S1, P0
cmovl P3, P2
cmovl P2, S0
cmp S1, P1
cmovle P0, P1
cmovle P1, S1
cmovl S1, P0
cmp P2, P0
cmovge S1, P2
cmovle P0, P2
cmp P3, P1
cmovl P2, P3
