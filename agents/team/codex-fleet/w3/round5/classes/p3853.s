# n=5 model=out iset=I1 prefix14_class=3853
mov S0, P3
cmp S0, P2
cmovge P3, P2
cmovg P2, S0
cmp P0, P1
cmovge S1, P0
cmovl S1, P1
cmovl P1, P0
cmp P3, P1
mov S2, P3
cmovl P3, P1
cmovl P1, S2
cmp P2, S1
cmovge P1, S1
