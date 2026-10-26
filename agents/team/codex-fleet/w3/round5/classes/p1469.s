# n=5 model=out iset=I1 prefix14_class=1469
mov S2, P1
cmp S2, P2
mov S0, P3
cmovg P1, P2
cmovg P2, S2
cmp S0, P0
cmovl P3, P0
cmovl P0, S0
cmp P2, P3
cmovge S1, P3
cmovl S1, P2
cmovl P2, P3
cmp P1, P0
mov P3, P0
