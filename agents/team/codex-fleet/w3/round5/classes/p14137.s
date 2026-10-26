# n=5 model=out iset=I1 prefix14_class=14137
mov S1, P3
cmp P2, S1
mov S0, P1
cmovge S1, P2
cmovl P3, P2
cmp P0, P1
cmovge P1, P0
cmovg P0, S0
cmp S1, P1
cmovl P2, S1
mov S2, P0
cmovl S1, P1
cmovl P1, P2
cmp P3, P0
