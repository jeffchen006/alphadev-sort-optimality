# n=5 model=out iset=I1 prefix14_class=5018
cmp P0, P2
mov S0, P2
mov S1, P1
cmovl S0, P0
cmovg P2, P0
cmp P1, P3
cmovge S1, P3
cmovl P1, P3
cmp S0, S1
cmovle P0, S1
cmovl S1, S0
cmovg P0, S0
cmp P1, P2
cmovge S2, P1
