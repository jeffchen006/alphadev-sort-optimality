# n=5 model=out iset=I1 prefix14_class=5326
mov S2, P3
cmp P1, P2
mov S1, P2
cmovge S1, P1
cmovl P2, P1
cmp P3, P0
cmovge S2, P0
cmovl P3, P0
cmp S2, P2
cmovl S0, P2
cmovge S0, S2
cmovl P2, S2
mov S2, P3
mov P2, S0
