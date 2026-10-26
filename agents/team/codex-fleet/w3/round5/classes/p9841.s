# n=5 model=out iset=I1 prefix14_class=9841
mov S2, P0
mov S1, P3
cmp P2, P0
cmovl P0, P2
cmovge S2, P2
cmp P3, P1
cmovg P3, P1
cmovl S1, P1
cmp S1, S2
cmovge S0, S1
cmovge S1, S2
cmovl S0, S2
cmp P3, P0
cmovl P2, P0
