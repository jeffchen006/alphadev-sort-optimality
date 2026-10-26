# n=5 model=out iset=I1 prefix14_class=3422
mov S1, P3
cmp S1, P0
cmovl P3, P0
cmovl P0, S1
cmp P1, P2
cmovge S0, P1
cmovge P1, P2
cmovl S0, P2
cmp P1, P0
cmovge P2, P1
cmovl P2, P0
cmovl P0, P1
cmp S0, P3
cmovl P1, P3
