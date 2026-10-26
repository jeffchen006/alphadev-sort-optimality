# n=5 model=out iset=I1 prefix14_class=10651
cmp P2, P1
cmovl S2, P1
cmovl P1, P2
mov S1, P3
cmovl P2, S2
mov S0, P2
cmp P0, S1
cmovge S1, P0
cmovg P0, P3
cmp S0, S1
mov P3, P0
cmovge P2, S1
cmovge S1, S0
cmp P1, P0
