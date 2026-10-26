# n=5 model=out iset=I1 prefix14_class=5782
mov S1, P1
cmp S1, P0
cmovl S1, P0
cmovge P1, P0
mov S2, P2
cmp P3, P2
cmovge P2, P3
cmovl S2, P3
cmp S2, P1
cmovge S0, S2
cmovl S0, P1
cmovl P1, S2
cmp S1, P2
cmovl P0, P2
