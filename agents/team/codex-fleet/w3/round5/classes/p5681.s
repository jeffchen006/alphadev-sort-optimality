# n=5 model=out iset=I1 prefix14_class=5681
cmp P3, P1
mov S0, P3
cmovge S0, P1
cmovg P1, P3
mov S2, P2
cmp S2, P0
cmovge P2, P0
cmovge P0, S2
cmp P2, S0
cmovl S2, S0
cmovl S0, P2
mov S0, P1
cmovl P2, S2
cmp P0, P1
