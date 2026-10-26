# n=5 model=out iset=I1 prefix14_class=9451
cmp P3, P1
mov S1, P1
mov S0, P0
cmovl S1, P3
cmovl P3, P1
cmp P0, P2
cmovge P0, P2
cmovl S0, P2
mov S2, S1
cmp P0, S1
cmovl S1, P0
cmovge S2, P0
cmp S0, P3
cmovge P1, P3
