# n=5 model=out iset=I1 prefix14_class=13045
mov S0, P0
cmp P2, S0
cmovl P0, P2
cmovge S0, P2
cmp P3, P1
cmovle P2, P3
cmovl P3, P1
cmovl P1, P2
mov S1, P0
cmp P0, P1
cmovl P0, P1
cmovl P1, S1
cmp S0, P3
mov P1, P3
