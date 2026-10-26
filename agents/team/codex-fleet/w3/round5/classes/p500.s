# n=5 model=out iset=I1 prefix14_class=500
cmp P3, P0
cmovge S1, P0
cmovl S1, P3
mov S0, P1
cmovg P0, P3
cmp P1, P2
cmovge P1, P2
cmovge P2, S0
mov P3, P1
cmp S1, P1
cmovl P1, S1
cmovl S1, P3
cmp P0, P2
mov P1, P0
