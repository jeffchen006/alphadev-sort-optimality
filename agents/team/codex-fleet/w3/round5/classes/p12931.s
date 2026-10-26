# n=5 model=out iset=I1 prefix14_class=12931
mov S1, P1
cmp P1, P2
cmovge S1, P2
cmovl P1, P2
cmp P0, P3
cmovl S2, P0
cmovge S2, P3
cmovg P3, P0
mov S0, S1
cmp S2, S0
cmovl S0, S2
cmovg S1, S2
cmp P1, P3
cmovge S0, P3
