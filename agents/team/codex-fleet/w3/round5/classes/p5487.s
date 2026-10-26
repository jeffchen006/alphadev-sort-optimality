# n=5 model=out iset=I1 prefix14_class=5487
cmp P1, P0
cmovl S0, P0
cmovl P0, P1
cmovl P1, S0
cmp P2, P3
mov S2, P2
cmovge S2, P3
mov S1, S2
cmovl P2, P3
cmp S1, P0
cmovl S1, P0
cmovle P0, S2
mov P0, P1
cmp P1, P2
