# n=5 model=out iset=I1 prefix14_class=240
cmp P0, P1
mov S0, P2
mov S2, P1
cmovge S2, P0
cmovl P1, P0
cmp P2, P3
cmovge S0, P3
mov S1, P1
cmovge P3, P2
mov P0, S2
cmp S0, S1
cmovl S1, S0
cmovl S0, P1
cmp S2, P3
