# n=5 model=out iset=I1 prefix14_class=6997
cmp P3, P1
cmovl S0, P1
cmovle P1, P3
mov S1, P0
cmovge S0, P3
mov P3, P1
cmp P2, P0
cmovl S1, P2
cmovl P2, P0
cmp P1, S1
cmovle P3, S1
cmovl S1, P1
cmp S0, P2
cmovl P1, P3
