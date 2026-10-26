# n=5 model=out iset=I1 prefix14_class=7364
cmp P1, P3
mov S1, P1
cmovl P1, P3
mov S0, P1
cmovl P3, S1
mov S2, P2
cmp P0, P2
cmovge S2, P0
cmovl P2, P0
cmp P2, P3
cmovl P0, P2
cmovl P2, P3
cmovl P3, P0
cmp S2, P1
