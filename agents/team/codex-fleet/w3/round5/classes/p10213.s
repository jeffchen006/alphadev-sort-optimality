# n=5 model=out iset=I1 prefix14_class=10213
cmp P3, P0
mov S2, P3
cmovg S2, P0
mov S0, P2
cmovge P0, P3
cmp P1, S0
cmovge S0, P1
cmovl P2, P1
cmp S0, P0
cmovl S1, P0
cmovl P0, S0
mov P1, P2
cmovl S0, S1
cmp P1, S2
