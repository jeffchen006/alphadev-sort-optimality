# n=5 model=out iset=I1 prefix14_class=8167
mov S2, P3
cmp P3, P1
cmovl S2, P1
cmovl P1, P3
cmp P0, P2
cmovg P3, P0
cmovg P0, P2
cmovg P2, P3
cmp P1, P0
mov S0, P1
cmovge S0, P0
cmovl P1, P0
mov S0, P2
cmp P2, S2
