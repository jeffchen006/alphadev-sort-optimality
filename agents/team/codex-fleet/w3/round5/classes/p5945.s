# n=5 model=out iset=I1 prefix14_class=5945
mov S2, P2
cmp P3, P1
cmovge S0, P3
cmovl S0, P1
cmovle P1, P3
cmp P0, P2
cmovg P2, P0
cmovl S2, P0
cmp P2, S0
cmovl P0, S0
cmovl S0, P2
cmovl P2, P0
cmp P1, S2
cmovge S1, S2
