# n=5 model=out iset=I1 prefix14_class=184
cmp P0, P2
mov S2, P0
cmovl S2, P2
cmovge P0, P2
mov S1, P1
cmp P3, P1
cmovl P1, P3
cmovl P3, S1
mov S0, S2
mov P2, P1
cmp P0, P1
cmovg P2, P0
cmovl P1, P0
cmp S2, P3
