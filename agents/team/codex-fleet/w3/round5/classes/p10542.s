# n=5 model=out iset=I1 prefix14_class=10542
cmp P1, P2
mov S1, P1
cmovl P1, P2
mov S0, P3
cmovl P2, S1
cmp P0, S0
cmovle P3, P0
cmovge S0, P0
cmp S0, P1
cmovl S1, S0
cmovle S0, P1
cmovl P1, S1
cmp P2, P3
mov S0, P3
