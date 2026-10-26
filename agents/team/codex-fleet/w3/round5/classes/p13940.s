# n=5 model=out iset=I1 prefix14_class=13940
mov S2, P2
cmp S2, P0
cmovl P2, P0
cmovge S2, P0
cmp P3, P1
cmovl S1, P1
cmovl P1, P3
cmovl P3, S1
mov S0, P2
cmp P3, S0
cmovge S0, P3
cmovle P2, P3
cmp S2, P1
cmovl S0, S2
