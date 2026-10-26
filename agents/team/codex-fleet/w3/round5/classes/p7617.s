# n=5 model=out iset=I1 prefix14_class=7617
cmp P0, P1
cmovl S2, P0
cmovl P0, P1
cmovl P1, S2
mov S1, P3
cmp P2, P3
cmovl S1, P2
mov S0, P1
cmovg P3, P2
cmp P1, S1
cmovge S0, S1
mov S0, P3
cmovge S1, P1
cmp P0, S0
