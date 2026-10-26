# n=5 model=out iset=I1 prefix14_class=3977
mov S1, P1
mov S0, P3
cmp S1, P2
cmovl S1, P2
cmovg P1, P2
cmp P0, P3
mov S2, P1
cmovl S0, P0
cmovg P3, P0
cmp S0, S2
cmovge S2, S0
cmovge S0, P1
cmp P3, S1
cmovl P0, S1
