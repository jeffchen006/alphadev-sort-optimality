# n=5 model=out iset=I1 prefix14_class=12025
mov S0, P2
cmp S0, P1
cmovl S0, P1
cmovg P2, P1
cmp P0, P3
mov S1, P0
cmovge S1, P3
cmovl P0, P3
cmp S1, P2
cmovl S2, P2
cmovge S2, S1
cmovl P2, S1
cmp S0, P0
cmovl P3, P0
