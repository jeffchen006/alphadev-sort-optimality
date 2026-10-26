# n=5 model=out iset=I1 prefix14_class=1758
cmp P1, P0
cmovge S0, P0
cmovg P0, P1
cmovg P1, S0
mov S0, P2
cmp P3, P2
cmovl S0, P3
cmovl P3, P2
mov S1, P0
cmp S1, P3
cmovge S1, P3
cmovl P0, P3
mov P3, S1
mov P0, S0
