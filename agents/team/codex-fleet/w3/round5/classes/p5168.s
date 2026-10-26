# n=5 model=out iset=I1 prefix14_class=5168
mov S1, P0
cmp P0, P1
cmovl P0, P1
cmovl P1, S1
mov S0, P0
mov S2, P2
cmp P3, S2
cmovl S2, P3
cmovl P3, P2
cmp S2, P1
cmovge P2, S2
cmovge S2, P1
cmovge P1, P2
cmp P3, S0
