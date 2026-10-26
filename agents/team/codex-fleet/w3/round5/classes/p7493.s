# n=5 model=out iset=I1 prefix14_class=7493
mov S0, P2
cmp P2, P0
mov S1, P1
cmovl S0, P0
cmovg P2, P0
cmp P1, P3
cmovge S1, P3
cmovl P1, P3
mov P0, P2
cmp S1, P0
cmovg P2, S1
cmovl P0, S1
cmp P1, S0
cmovge S1, S0
