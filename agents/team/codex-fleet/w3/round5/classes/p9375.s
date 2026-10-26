# n=5 model=out iset=I1 prefix14_class=9375
mov S1, P3
cmp P3, P1
cmovl S1, P1
cmovl P1, P3
cmp P0, P2
cmovl P3, P2
cmovl P2, P0
cmovl P0, P3
mov S0, P1
cmp P2, P1
cmovg S0, P2
cmovg P2, P1
mov P1, P0
cmp S1, P1
