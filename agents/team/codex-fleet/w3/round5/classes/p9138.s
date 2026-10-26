# n=5 model=out iset=I1 prefix14_class=9138
cmp P3, P0
cmovge S0, P3
cmovl S0, P0
cmovl P0, P3
cmp P1, P2
cmovge S2, P2
cmovge P2, P1
cmovg P1, S2
cmp P1, P0
mov S1, P1
cmovl P1, P0
cmovge S1, P0
cmp S0, P2
mov S1, S0
