# n=5 model=out iset=I1 prefix14_class=7865
mov S0, P1
cmp P0, S0
cmovg P1, P0
cmovl S0, P0
cmp P3, P2
cmovge P0, P2
cmovg P2, P3
cmovl P0, P3
mov S2, P0
cmp S0, P0
cmovge S2, S0
cmovl P0, S0
cmp P2, P1
cmovl P0, P2
