# n=5 model=out iset=I1 prefix14_class=6503
cmp P0, P1
cmovl S1, P1
cmovl P1, P0
cmovge S1, P0
mov S2, P3
cmp P2, S2
cmovl P3, P2
cmovge S2, P2
cmp S1, S2
mov S0, S2
cmovl S2, S1
cmovl S1, S0
mov S0, S2
mov S1, P3
