# n=5 model=out iset=I1 prefix14_class=4427
cmp P1, P2
mov S2, P1
cmovg P1, P2
mov S0, P0
cmovl S2, P2
cmp P0, P3
cmovge S0, P3
cmovg P3, P0
cmp P3, S2
cmovl P0, S2
cmovl S2, P3
cmovl P3, P0
mov P3, P1
cmp P3, S0
