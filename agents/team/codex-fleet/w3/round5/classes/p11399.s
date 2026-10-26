# n=5 model=out iset=I1 prefix14_class=11399
mov S2, P1
cmp P0, P3
cmovl S0, P3
cmovl P3, P0
cmovl P0, S0
cmp S2, P2
cmovg S2, P2
cmovl P1, P2
cmovg P2, P1
cmp P0, P1
cmovg P2, P0
cmovl P1, P0
cmp S2, P3
mov P0, P3
