# n=5 model=out iset=I1 prefix14_class=14366
mov S1, P1
cmp P1, P0
cmovge S1, P0
mov S0, S1
cmovl P1, P0
cmp P2, P3
cmovg P0, P2
cmovge P2, P3
cmovg P3, P0
cmp S0, P2
cmovl S0, P2
cmovl P2, S1
cmp P1, P3
mov S2, P3
