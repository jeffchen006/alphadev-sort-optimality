# n=5 model=out iset=I1 prefix14_class=12040
cmp P2, P3
cmovge S2, P3
cmovg P3, P2
cmovg P2, S2
cmp P1, P0
cmovl S0, P0
cmovl P0, P1
cmovl P1, S0
cmp P0, P2
mov S0, P0
cmovl P0, P2
cmovge S0, P2
mov S0, P0
cmp P3, P1
