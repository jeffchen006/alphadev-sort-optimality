# n=5 model=out iset=I1 prefix14_class=10550
mov S0, P2
cmp P1, S0
cmovl P2, P1
cmovg S0, P1
cmp P3, P0
cmovge S2, P3
cmovl S2, P0
cmovl P0, P3
cmp S0, S2
cmovl P3, S0
cmovl S0, S2
cmovl S2, P3
cmp P0, P2
cmovge P1, P0
