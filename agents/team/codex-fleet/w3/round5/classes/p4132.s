# n=5 model=out iset=I1 prefix14_class=4132
mov S0, P0
cmp P2, S0
cmovl P0, P2
mov S1, P3
cmovge S0, P2
cmp P1, S1
cmovl S1, P1
cmovge P3, P1
mov S2, P0
mov P1, S0
cmp S1, P0
cmovge P0, S1
cmovge S1, S2
mov S1, P0
