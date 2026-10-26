# n=5 model=out iset=I1 prefix14_class=4353
cmp P1, P2
cmovl S1, P1
cmovle P1, P2
cmovge S1, P2
cmp P3, P0
cmovle P2, P0
cmovle P0, P3
cmovl P3, P2
mov S0, S1
cmp S1, P0
cmovl S1, P0
cmovle P0, S0
mov P0, S1
cmp P3, P1
