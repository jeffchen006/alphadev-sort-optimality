# n=5 model=out iset=I1 prefix14_class=10446
cmp P2, P0
mov S0, P1
cmovge S2, P0
cmovg P0, P2
cmovl S2, P2
cmp S0, P3
cmovl S0, P3
cmovge P1, P3
cmp P0, S0
cmovl S1, P0
cmovl P0, S0
cmovl S0, S1
cmp P1, S2
cmovl P3, P1
