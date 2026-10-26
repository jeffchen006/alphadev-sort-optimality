# n=5 model=out iset=I1 prefix14_class=3747
cmp P0, P3
mov S0, P3
mov S2, P2
cmovl S0, P0
cmovg P3, P0
mov P0, S0
cmp P1, P2
cmovge S2, P1
cmovg P1, P2
cmp P1, P0
cmovl P0, P1
cmovge S0, P1
cmp S2, P3
cmovl P1, S2
