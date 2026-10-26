# n=5 model=out iset=I1 prefix14_class=8252
mov S0, P3
cmp S0, P1
cmovg P3, P1
cmovl S0, P1
mov P1, P3
cmp P0, P2
cmovge S1, P2
cmovge P2, P0
cmovg P0, S1
cmp P3, P0
mov S2, S0
cmovl P1, P0
cmovg P3, P0
mov P3, P1
