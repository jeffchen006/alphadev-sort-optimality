# n=5 model=out iset=I1 prefix14_class=13600
cmp P1, P0
cmovge S1, P1
cmovl S1, P0
cmovl P0, P1
cmp P3, P2
mov S0, P2
cmovle P2, P3
cmovl P3, S0
cmp P2, P0
cmovle S0, P0
cmovl P0, P2
cmovl P2, S0
cmp S1, P3
cmovge S0, P3
