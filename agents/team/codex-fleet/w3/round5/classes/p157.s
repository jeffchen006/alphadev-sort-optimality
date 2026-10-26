# n=5 model=out iset=I1 prefix14_class=157
mov S0, P3
cmp S0, P0
mov S1, P1
cmovl P3, P0
cmovge S0, P0
cmp P2, P1
cmovl P1, P2
cmovl P2, S1
cmp S0, P1
cmovge S2, S0
mov S1, P2
cmovge S0, P1
cmovl S2, P1
mov P0, S2
