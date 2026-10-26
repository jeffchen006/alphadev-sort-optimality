# n=5 model=out iset=I1 prefix14_class=1382
mov S0, P0
cmp P3, P2
mov S1, P2
cmovg P2, P3
cmovl S1, P3
cmp P0, P1
mov P3, P2
cmovge S0, P1
cmovg P1, P0
cmp P1, P3
cmovg P3, P1
mov P3, S1
cmovl P2, P1
cmp S1, S0
