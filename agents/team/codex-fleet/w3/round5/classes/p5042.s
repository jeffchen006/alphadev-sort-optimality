# n=5 model=out iset=I1 prefix14_class=5042
mov S2, P3
cmp P0, S2
mov S0, P2
cmovg P3, P0
cmovge P0, S2
cmovl S2, P0
cmp P1, P2
cmovl S0, P1
cmovg P2, P1
cmp S0, S2
cmovl P0, S0
cmovge S2, S0
cmp P3, P2
mov P0, S2
