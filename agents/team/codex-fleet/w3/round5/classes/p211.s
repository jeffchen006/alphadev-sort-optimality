# n=5 model=out iset=I1 prefix14_class=211
cmp P3, P2
mov S0, P0
cmovl S1, P3
cmovl P3, P2
cmovl P2, S1
cmp S0, P1
cmovg P0, P1
cmovge P1, S0
cmp P0, P2
mov S2, P0
cmovl P0, P2
mov S0, P1
mov S1, P0
cmovl P2, S2
