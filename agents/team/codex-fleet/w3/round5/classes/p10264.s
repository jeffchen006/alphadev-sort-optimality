# n=5 model=out iset=I1 prefix14_class=10264
cmp P2, P3
cmovl S2, P3
cmovl P3, P2
cmovl P2, S2
cmp P1, P0
cmovl S1, P1
cmovge S1, P0
cmovle P1, P0
cmp P2, P1
mov S0, P2
cmovl P2, P1
cmovle P1, S0
mov P2, P3
cmp S1, P3
