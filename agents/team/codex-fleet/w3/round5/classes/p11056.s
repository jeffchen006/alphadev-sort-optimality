# n=5 model=out iset=I1 prefix14_class=11056
mov S1, P1
cmp P0, P1
cmovle P1, P0
cmovge S1, P0
cmp P3, P2
cmovl S0, P3
cmovle P3, P2
mov P0, P1
cmovl P2, S0
cmp S1, P3
cmovl S0, S1
cmovl S1, P3
cmovl P3, S0
cmp P1, P2
