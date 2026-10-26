# n=5 model=out iset=I1 prefix14_class=10701
cmp P2, P0
cmovl S0, P2
cmovl P2, P0
cmovl P0, S0
mov S2, P1
cmp P3, S2
mov S1, P2
cmovg S2, P3
cmovle P1, P3
cmp S1, S2
cmovl P2, S2
cmovl S2, S1
cmp P1, P0
cmovge S0, P0
