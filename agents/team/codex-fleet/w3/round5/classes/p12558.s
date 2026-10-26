# n=5 model=out iset=I1 prefix14_class=12558
cmp P1, P3
cmovl S1, P1
cmovl P1, P3
cmovl P3, S1
mov S2, P2
cmp P2, P0
cmovge S2, P0
cmovle P2, P0
cmp S2, P3
mov P0, P2
cmovl S0, P3
cmovl P3, S2
cmovl S2, S0
cmp P2, P1
