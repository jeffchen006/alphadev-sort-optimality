# n=5 model=out iset=I1 prefix14_class=2899
cmp P0, P3
mov S0, P3
cmovl S0, P0
cmovl P0, P3
cmp P1, P2
mov S1, P1
cmovge P1, P2
cmovl S1, P2
mov S2, P0
cmp S2, S1
cmovl S2, S1
cmovl S1, P0
mov S2, P1
mov P3, S1
