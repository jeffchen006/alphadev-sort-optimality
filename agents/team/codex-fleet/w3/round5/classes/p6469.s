# n=5 model=out iset=I1 prefix14_class=6469
mov S0, P3
cmp P3, P0
cmovl S0, P0
mov S2, P2
cmovl P0, P3
cmp P1, S2
cmovle P2, P1
cmovge S2, P1
cmp S2, S0
cmovl S1, S2
cmovge S1, S0
cmovl S2, S0
cmp P0, P2
cmovle P1, P2
