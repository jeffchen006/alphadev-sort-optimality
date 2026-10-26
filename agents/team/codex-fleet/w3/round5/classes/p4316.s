# n=5 model=out iset=I1 prefix14_class=4316
cmp P2, P3
cmovge S0, P3
cmovl S0, P2
cmovl P2, P3
mov S2, P1
cmp P0, P1
cmovle P1, P0
mov S1, P1
cmovl P0, S2
cmp S1, S0
cmovle P1, S0
cmovl S0, S1
mov P3, P1
cmp P0, P2
