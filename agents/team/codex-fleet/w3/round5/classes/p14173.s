# n=5 model=out iset=I1 prefix14_class=14173
mov S1, P2
cmp P0, P2
mov S0, P1
cmovl P2, P0
cmovge S1, P0
cmp S0, P3
cmovl S0, P3
cmovl P3, P1
mov S2, P3
cmp S1, S0
cmovge P1, S0
cmovge S0, S1
cmovge S1, P1
cmp P2, P3
