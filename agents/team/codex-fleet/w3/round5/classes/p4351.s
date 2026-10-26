# n=5 model=out iset=I1 prefix14_class=4351
cmp P1, P2
cmovl S0, P1
cmovle P1, P2
cmovge S0, P2
cmp P3, P0
mov P2, P0
cmovle P0, P3
cmovl P3, P2
cmp S0, P0
mov S2, S0
cmovl S0, P0
cmovle P0, S2
mov P0, S0
cmp P1, P3
