# n=5 model=out iset=I1 prefix14_class=501
cmp P3, P0
cmovge S2, P0
cmovl S2, P3
mov S0, P1
cmovg P0, P3
cmp P1, P2
cmovge P1, P2
cmovge P2, S0
mov S1, P1
cmp S2, P1
cmovl P1, S2
cmovl S2, S1
cmp P0, P2
mov P1, P0
