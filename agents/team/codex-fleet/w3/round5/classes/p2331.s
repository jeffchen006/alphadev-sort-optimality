# n=5 model=out iset=I1 prefix14_class=2331
cmp P2, P1
mov S1, P2
cmovge P2, P1
cmovl S1, P1
mov S0, P3
cmp S0, P0
cmovge S0, P0
cmovl P3, P0
cmp S1, P3
mov S2, P3
cmovl P3, S1
cmovge S2, S1
cmp S0, P2
cmovge P0, S0
