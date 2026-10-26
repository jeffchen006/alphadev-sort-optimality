# n=5 model=out iset=I1 prefix14_class=13737
cmp P3, P2
cmovl S0, P2
cmovl P2, P3
cmovl P3, S0
mov S1, P1
cmp S1, P0
cmovg P1, P0
cmovl S1, P0
mov P0, P3
cmp S1, P3
cmovg P0, S1
cmovg S1, P3
cmp P2, P1
mov P3, P2
