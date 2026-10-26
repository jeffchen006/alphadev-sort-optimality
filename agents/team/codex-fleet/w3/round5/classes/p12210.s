# n=5 model=out iset=I1 prefix14_class=12210
cmp P0, P1
cmovl S2, P0
cmovl P0, P1
cmovl P1, S2
cmp P3, P2
cmovge S0, P2
cmovl S0, P3
cmovl P3, P2
mov S1, P1
cmp P1, S0
cmovge S1, S0
cmovge S0, P1
cmp P0, P3
cmovl P1, P3
