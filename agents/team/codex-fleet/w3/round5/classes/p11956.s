# n=5 model=out iset=I1 prefix14_class=11956
cmp P3, P0
cmovge S0, P0
cmovg P0, P3
cmovl S0, P3
mov S1, P1
cmp P1, P2
cmovl S1, P2
cmovl P2, P1
cmp S1, P0
cmovg P3, S1
cmovge S1, P0
mov S2, P2
cmovg P0, P3
cmp S2, S0
