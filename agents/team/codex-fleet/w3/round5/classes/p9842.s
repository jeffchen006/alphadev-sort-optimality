# n=5 model=out iset=I1 prefix14_class=9842
mov S2, P0
cmp P2, P0
cmovl P0, P2
cmovge S2, P2
mov S1, P1
cmp S1, P3
cmovg P1, P3
cmovl S1, P3
cmp S1, S2
cmovge S0, S1
cmovge S1, S2
cmovl S0, S2
cmp P1, P0
cmovl P2, P0
