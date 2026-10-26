# n=5 model=out iset=I1 prefix14_class=5136
mov S0, P0
mov S1, P1
cmp P3, P0
cmovge S0, P3
cmovle P0, P3
cmp P2, S1
cmovl S1, P2
cmovl P2, P1
cmp P0, S1
cmovge P1, S1
cmovge S1, P0
cmovl P1, P0
cmp S0, P2
cmovle P3, S0
