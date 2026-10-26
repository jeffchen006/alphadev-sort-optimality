# n=5 model=out iset=I1 prefix14_class=10566
cmp P3, P0
mov S1, P0
cmovl P0, P3
cmovge S1, P3
cmp P2, P1
cmovge S0, P1
cmovg P1, P2
mov S2, S1
cmovg P2, S0
cmp S1, P1
cmovl S2, P1
cmovge S1, P1
mov S2, P2
cmp S2, P0
