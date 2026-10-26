# n=5 model=out iset=I1 prefix14_class=3944
mov S0, P3
cmp P0, S0
cmovl P3, P0
cmovge S0, P0
mov P0, P2
cmp P0, P1
cmovl P2, P1
cmovl P1, P0
cmp P3, P1
cmovge S2, P1
cmovl S2, P3
cmovg P1, P3
mov P3, S0
cmp P3, P2
